package io.pivotal;

import org.springframework.amqp.AmqpConnectException;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.ReflectionUtils;

import javax.sql.DataSource;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * Created by benwilcock on 04/08/2016.
 */

@Component
public class Status {

    @Autowired(required = false)
    DataSource dataSource;

    @Autowired(required = false)
    ConnectionFactory rabbitConnectionFactory;

    public Status() {
    }

    public String getSql() {
        StringBuilder sb = new StringBuilder();

        if (dataSource == null) {
            sb.append("NOT_CONFIGURED");
        } else {
            try {
                Field urlField = ReflectionUtils.findField(dataSource.getClass(), "url");
                ReflectionUtils.makeAccessible(urlField);
                sb.append(urlField.get(dataSource));
                sb.append(":UP");
            } catch (Exception fe) {
                try {
                    Method urlMethod = ReflectionUtils.findMethod(dataSource.getClass(), "getUrl");
                    ReflectionUtils.makeAccessible(urlMethod);
                    sb.append(urlMethod.invoke(dataSource, (Object[]) null));
                    sb.append(":UP");
                } catch (Exception me) {
                    sb.append(":DOWN - ");
                    sb.append(me.getCause().getMessage());
                }
            }
        }
        return sb.toString();
    }

    public String getRabbit() {
        StringBuilder sb = new StringBuilder();

        if (rabbitConnectionFactory == null) {
            sb.append("NOT_CONFIGURED");
        } else {
            try {
                rabbitConnectionFactory.createConnection().isOpen();
                sb.append(rabbitConnectionFactory.getHost());
                sb.append(":");
                sb.append(rabbitConnectionFactory.getPort());
                sb.append(":UP");
            } catch (AmqpConnectException ce) {
                sb.append("NOT_PRESENT (");
                sb.append(ce.getCause().getMessage());
                sb.append(")");
            }
        }
        return sb.toString();
    }

    public boolean isSql() {
        return !(null == dataSource);
    }

    public boolean isRabbit() {
        return !(null == rabbitConnectionFactory);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("DATABASE: [");
        sb.append(getSql());
        sb.append("] MESSAGING: [");
        sb.append(getRabbit());
        sb.append("]");
        return sb.toString();
    }
}