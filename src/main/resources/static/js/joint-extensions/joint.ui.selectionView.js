/*
 * 
 */
joint.ui.SelectionView = Backbone.View.extend({

	className : 'selection',

	options : {
		paper : undefined,
		graph : undefined
	},

	events : {
		'mousedown .selection-box' : 'startTranslatingSelection'
	},

	constructor: function(options) {
		this._configure(options);
		Backbone.View.apply(this, arguments);
	},

	_configure: function(options) {
		if (this.options) options = _.extend({}, _.result(this, 'options'), options);
		this.options = options;
	},

	initialize : function() {
		_.bindAll(this, 'startSelecting', 'stopSelecting', 'adjustSelection');

		$(document.body).on('mouseup touchend', this.stopSelecting);
		$(document.body).on('mousemove touchmove', this.adjustSelection);

		this.options.paper.$el.append(this.$el);
	},

	startTranslatingSelection : function(evt) {
		this._action = 'translating';

		this.options.graph.trigger('batch:start');

		var snappedClientCoords = this.options.paper.snapToGrid(g.point(
				evt.clientX, evt.clientY));
		this._snappedClientX = snappedClientCoords.x;
		this._snappedClientY = snappedClientCoords.y;

		this.trigger('selection-box:pointerdown', evt);

		evt.stopPropagation();
	},

	startSelecting : function(evt, x, y) {
		this.$el.removeClass('selected');
		this.$el.empty();
		this.model.reset([]);

		this._action = 'selecting';

		this._clientX = evt.clientX;
		this._clientY = evt.clientY;

		// Normalize `evt.offsetX`/`evt.offsetY` for browsers that don't support it (Firefox).
		var paperElement = evt.target.parentElement || evt.target.parentNode;
		var paperOffset = $(paperElement).offset();
		var paperScrollLeft = paperElement.scrollLeft;
		var paperScrollTop = paperElement.scrollTop;

		this._offsetX = evt.offsetX === undefined ? evt.clientX - paperOffset.left + window.pageXOffset + paperScrollLeft : evt.offsetX;
		this._offsetY = evt.offsetY === undefined ? evt.clientY - paperOffset.top + window.pageYOffset + paperScrollTop : evt.offsetY;

		this.$el.css({
			width : 1,
			height : 1,
			left : this._offsetX,
			top : this._offsetY
		}).show();
	},

	adjustSelection : function(evt) {
		var dx;
		var dy;

		switch (this._action) {

			case 'selecting':

				dx = evt.clientX - this._clientX;
				dy = evt.clientY - this._clientY;

				var width = this.$el.width();
				var height = this.$el.height();
				var left = parseInt(this.$el.css('left'), 10);
				var top = parseInt(this.$el.css('top'), 10);

				this.$el.css({
					left : dx < 0 ? this._offsetX + dx : left,
					top : dy < 0 ? this._offsetY + dy : top,
					width : Math.abs(dx),
					height : Math.abs(dy)
				});
				break;

			case 'translating':

				var snappedClientCoords = this.options.paper.snapToGrid(g.point(evt.clientX, evt.clientY));
				var snappedClientX = snappedClientCoords.x;
				var snappedClientY = snappedClientCoords.y;

				dx = snappedClientX - this._snappedClientX;
				dy = snappedClientY - this._snappedClientY;

				// This hash of flags makes sure we're not adjusting vertices of one link twice.
				// This could happen as one link can be an inbound link of one element in the selection
				// and outbound link of another at the same time.
				var processedLinks = {};

				this.model.each(function(element) {
					// TODO: snap to grid.

					// Translate the element itself.
					element.translate(dx, dy);

					// Translate link vertices as well.
					var connectedLinks = this.options.graph.getConnectedLinks(element);

					_.each(connectedLinks, function(link) {
						if (processedLinks[link.id])
							return;

						var vertices = link.get('vertices');

						if (vertices && vertices.length) {
							var newVertices = [];
							_.each(vertices, function(vertex) {
								newVertices.push({
									x : vertex.x + dx,
									y : vertex.y + dy
								});
							});

							link.set('vertices', newVertices);
						}

						processedLinks[link.id] = true;
					});

				}, this);

				if (dx || dy) {
					var paperScale = V(this.options.paper.viewport).scale();
					dx *= paperScale.sx;
					dy *= paperScale.sy;

					// Translate also each of the `selection-box`.
					this.$('.selection-box').each(function() {

						var left = parseFloat($(this).css('left'), 10);
						var top = parseFloat($(this).css('top'), 10);
						$(this).css({
							left : left + dx,
							top : top + dy
						});
					});

					this._snappedClientX = snappedClientX;
					this._snappedClientY = snappedClientY;
				}

				break;
		}
	},

	stopSelecting : function() {
		switch (this._action) {

			case 'selecting':

				var offset = this.$el.offset();
				var width = this.$el.width();
				var height = this.$el.height();

				// Convert offset coordinates to the local point of the <svg> root element.
				var localPoint = V(this.options.paper.svg).toLocalPoint(offset.left, offset.top);

				// Take page scroll into consideration.
				localPoint.x -= window.pageXOffset;
				localPoint.y -= window.pageYOffset;

				var elementViews = this.options.paper.findViewsInArea(g.rect(localPoint.x, localPoint.y, width, height));

				if (elementViews.length) {
					// Create a `selection-box` `<div>` for each element covering its bounding box area.
					_.each(elementViews, this.createSelectionBox, this);

					// The root element of the selection switches `position` to `static` when `selected`.
					// This is neccessary in order for the `selection-box` coordinates to be relative to the
					// `paper` element, not the `selection` `<div>`.
					this.$el.addClass('selected');
				} else {
					// Hide the selection box if there was no element found in the area covered by the selection box.
					this.$el.hide();
				}

				this.model.reset(_.pluck(elementViews, 'model'));
				break;

			case 'translating':

				this.options.graph.trigger('batch:stop');
				// Everything else is done during the translation.
				break;

			case 'cherry-picking':
				// noop; All is done in the `createSelectionBox()` function.
				// This is here to avoid removing selection boxes as a reaction on mouseup event and
				// propagating to the `default` branch in this switch.
				break;

			default:
				// Hide selection if the user clicked somehwere else in the document.
				this.$el.hide().empty();
				this.model.reset([]);
				break;
		}

		delete this._action;
	},

	cancelSelection : function() {
		this.$('.selection-box').remove();
		this.$el.hide().removeClass('selected');
		this.model.reset([]);
	},

	destroySelectionBox : function(elementView) {
		this.$('[data-model="' + elementView.model.get('id') + '"]').remove();
		if (this.$('.selection-box').length === 0) {
			this.$el.hide().removeClass('selected');
		}
	},

	createSelectionBox : function(elementView) {
		var viewBbox = elementView.getBBox();

		var $selectionBox = $('<div/>', {
			'class' : 'selection-box',
			'data-model' : elementView.model.get('id')
		});
		$selectionBox.css({
			left : viewBbox.x,
			top : viewBbox.y,
			width : viewBbox.width,
			height : viewBbox.height
		});
		this.$el.append($selectionBox);

		this.$el.addClass('selected').show();

		this._action = 'cherry-picking';
	}
});
