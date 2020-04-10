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
import org.springframework.context.annotation.Primary;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@MapperScan(value="com.tops.mapper.fwk", sqlSessionFactoryRef="sqlSessionFactoryFWK")
@EnableTransactionManagement
public class fwkdbConfig
{
    @Bean(name = "dataSourceFWK")
    @Primary
    @ConfigurationProperties(prefix = "fwkdb.datasource")
    public DataSource dataSourceFWK()
    {
        return DataSourceBuilder.create().build();
    }

    @Bean(name = "sqlSessionFactoryFWK")
    @Primary
    public SqlSessionFactory sqlSessionFactoryFWK(@Qualifier("dataSourceFWK") DataSource dataSourceFWK, ApplicationContext applicationContext) throws Exception
    {
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(dataSourceFWK);
        sqlSessionFactoryBean.setConfigLocation(applicationContext.getResource("classpath:mybatis-config.xml"));
        sqlSessionFactoryBean.setMapperLocations(applicationContext.getResources("classpath:mapper/fwk/*.xml"));
        sqlSessionFactoryBean.setVfs(SpringBootVFS.class);  // Spring Boot 전용 VFS 사용하도록 지정
        return sqlSessionFactoryBean.getObject();
    }

    @Bean(name = "sqlSessionReuseTemplateFWK")
    @Primary
    public SqlSessionTemplate sqlSessionReuseTemplateFWK(SqlSessionFactory sqlSessionFactoryFWK) throws Exception
    { 
        return new SqlSessionTemplate(sqlSessionFactoryFWK);
    }
}
