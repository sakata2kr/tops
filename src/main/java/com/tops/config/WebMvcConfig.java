package com.tops.config;

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

import com.tops.common.filter.SitemeshFilter;
import com.tops.common.interceptor.AuthenticationInterceptor;

@Configuration
@EnableWebMvc
@ComponentScan("com.tops")
public class WebMvcConfig implements WebMvcConfigurer
{
    // 1. sitemesh filter 설정
    @Bean
    public FilterRegistrationBean<SitemeshFilter> siteMeshFilter()
    {
        FilterRegistrationBean<SitemeshFilter> filter = new FilterRegistrationBean<SitemeshFilter>();

        filter.setFilter(new SitemeshFilter());

        return filter;
    }

    // 2. interceptor 설정
    @Bean
    public AuthenticationInterceptor authenticationInterceptor()
    {
        return new AuthenticationInterceptor();
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry)
    {
        registry.addInterceptor(authenticationInterceptor()).addPathPatterns("/**").excludePathPatterns("/login/**").excludePathPatterns("/resources/**");
    }

    // 3. view Resolver 설정
    @Bean
    public ViewResolver internalResourceViewResolver()
    {
        InternalResourceViewResolver bean = new InternalResourceViewResolver();
        bean.setViewClass(JstlView.class);
        bean.setPrefix("/WEB-INF/jsp/");
        bean.setSuffix(".jsp");
        return bean;
    }

    @Override
    public void addResourceHandlers (ResourceHandlerRegistry registry)
    {
        registry.addResourceHandler("/resources/**").addResourceLocations("classpath:/static/");
    }
}