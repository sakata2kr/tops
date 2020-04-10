package com.tops.config;

import javax.sql.DataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.mybatis.spring.boot.autoconfigure.SpringBootVFS;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@MapperScan(value="com.tops.mapper.urt", sqlSessionFactoryRef="sqlSessionFactoryURT")
@EnableTransactionManagement
public class urtdbConfig
{
    @Bean(name = "dataSourceURT")
    @ConfigurationProperties(prefix = "urtdb.datasource")
    public DataSource dataSourceURT()
    {
        return DataSourceBuilder.create().build();
    }

    @Bean(name = "sqlSessionFactoryURT")
    public SqlSessionFactory sqlSessionFactoryURT(@Qualifier("dataSourceURT") DataSource dataSourceURT, ApplicationContext applicationContext) throws Exception
    {
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(dataSourceURT);
        sqlSessionFactoryBean.setConfigLocation(applicationContext.getResource("classpath:mybatis-config.xml"));
        sqlSessionFactoryBean.setMapperLocations(applicationContext.getResources("classpath:mapper/urt/*.xml"));
        sqlSessionFactoryBean.setVfs(SpringBootVFS.class);
        return sqlSessionFactoryBean.getObject();
    }

    @Bean(name = "sqlSessionReuseTemplateURT")
    public SqlSessionTemplate sqlSessionReuseTemplateURT(SqlSessionFactory sqlSessionFactoryURT) throws Exception
    { 
        return new SqlSessionTemplate(sqlSessionFactoryURT);
    }
}
