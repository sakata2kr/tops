/*
 * 
 */
joint.ui.PaperScroller = Backbone.View.extend({

	className : 'paper-scroller',

	events : {
		//'mousedown' : 'pointerdown',
		//'mousemove' : 'pointermove',
		//'touchmove' : 'pointermove',
		//'mouseout' : 'stopPanning'
		'mousemove' : 'pan',
		'mouseout' : 'stopPanning'
	},

	/*options : {
		paper : undefined,
		padding : 0,
		autoResizePaper : false
	},*/

	constructor: function(options) {
		this._configure(options);
		Backbone.View.apply(this, arguments);
	},

	_configure: function(options) {
		if (this.options) options = _.extend({}, _.result(this, 'options'), options);
		this.options = options;
	},

	initialize : function() {
		_.bindAll(this, 'startPanning', 'stopPanning');

		/*var view = this.options.paper;
		var scale = V(view.viewport).scale();

		this._sx = scale.sx;
		this._sy = scale.sy;
		this._baseWidth = view.options.width;
		this._baseHeight = view.options.height;
		//this.$el.append(view.el), this.addPadding();
		this.listenTo(view, "scale", this.onScale);
		this.listenTo(view, "resize", this.onResize);

		// automatically resize the paper
		if (this.options.autoResizePaper) {
			this.listenTo(view.model, "change add remove reset", this.adjustPaper);
		}*/

		$(document.body).on('mouseup', this.stopPanning);
	},

	render : function() {
		this.listenTo(this.options.paper, 'scale resize', this.onScale);

		// automatically resize the paper
		if (this.options.autoResizePaper) {
			// keep the original paper size
			this._ow = this.options.paper.options.width;
			this._oh = this.options.paper.options.height;

			this.listenTo(this.options.paper.model, 'all', function() {
				this.options.paper.fitToContent(this._ow, this._oh);
			});
		}

		return this;
	},

	onResize : function() {
		this._center && this.center(this._center.x, this._center.y);
	},

	onScale : function(ox, oy) {
		var ctm = this.options.paper.viewport.getCTM(), sx = ctm.a, sy = ctm.d;

		// Cancel the viewport translation as it will be shifted by scrolling instead.
		V(this.options.paper.viewport).attr('transform', '');
		// Keep applied scale.
		V(this.options.paper.viewport).scale(sx, sy);
		// TODO: Keep applied rotation.

		V(this.options.paper.svg).attr({
			'width' : this.options.paper.options.width * sx,
			'height' : this.options.paper.options.height * sy
		});

		// Move scroller to scale origin.
		if (ox && oy)
			this.center(ox, oy);
	},

	center : function(ox, oy) {
		if (_.isUndefined(ox) || _.isUndefined(oy)) {

			ox = this.options.paper.options.width / 2;
			oy = this.options.paper.options.height / 2;
		}

		var ctm = this.options.paper.viewport.getCTM()
			, sx = ctm.a
			, sy = ctm.d
			, cx = this.el.clientWidth / sx / 2
			, cy = this.el.clientHeight / sy / 2;

		this.el.scrollLeft = (ox - cx) * sx;
		this.el.scrollTop = (oy - cy) * sy;
	},

	centerContent : function() {
		var vbox = V(this.options.paper.viewport).bbox(true, this.options.paper.svg);
		this.center(vbox.x + vbox.width / 2, vbox.y + vbox.height / 2);
	},

	startPanning : function(evt) {
		this._panning = true;

		this._clientX = evt.clientX;
		this._clientY = evt.clientY;
	},

	pan : function(evt) {
		if (!this._panning)
			return;

		var dx = evt.clientX - this._clientX;
		var dy = evt.clientY - this._clientY;

		this.el.scrollTop -= dy;
		this.el.scrollLeft -= dx;

		this._clientX = evt.clientX;
		this._clientY = evt.clientY;
	},

	stopPanning : function() {
		delete this._panning;
	}

});
