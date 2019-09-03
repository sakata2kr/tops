package com.tops.common.filter;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

public class SitemeshFilter extends ConfigurableSiteMeshFilter
{
    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder)
    {
        builder.addDecoratorPath("/main/mainPage", "/WEB-INF/jsp/main/defaultLayout.jsp");
    }
}