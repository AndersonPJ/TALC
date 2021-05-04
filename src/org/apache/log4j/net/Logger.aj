package org.apache.log4j.net;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import org.apache.log4j.helpers.LogLog;
import java.lang.reflect.Method;

public aspect Logger {
	/* 
	 * Constructor ZeroConfSupport 
	 */

	before() : call(Object ZeroConfSupport.buildServiceInfoVersion3(..)) {
		LogLog.debug("using JmDNS version 3 to construct serviceInfo instance");
	}

	before() : call(Object ZeroConfSupport.buildServiceInfoVersion1(..)) {
		LogLog.debug("using JmDNS version 1.0 to construct serviceInfo instance");
	}

	/*
	 * buildServiceInfoVersion1
	 */

	pointcut onNewInstance() : withincode(Object ZeroConfSupport.buildServiceInfoVersion1(..)) 
		&& call(Object Constructor.newInstance(..));

	after() throwing(Exception e) : onNewInstance() {
		if (e instanceof IllegalAccessException || e instanceof InstantiationException || e instanceof InvocationTargetException) {
			LogLog.warn("Unable to construct ServiceInfo instance", e);   
		}
	}

	after() returning(Object r) : onNewInstance() {
		LogLog.debug("created serviceinfo: " + r);
	}

	pointcut onGetConstructor() : withincode(Object ZeroConfSupport.buildServiceInfoVersion1(..))
		&& call(Constructor Class.getConstructor(..));

	after() throwing(NoSuchMethodException e) : onGetConstructor() {
		LogLog.warn("Unable to get ServiceInfo constructor", e);
	}

	/*
	 * buildServiceInfoVersion3
	 */

	pointcut onGetMethod() : withincode(Object ZeroConfSupport.buildServiceInfoVersion3(..))
		&& call(Method Class.getMethod(..));

	after() throwing(NoSuchMethodException e) : onGetMethod() {
		LogLog.warn("Unable to find create method", e);
	}

	pointcut onInvoke() : withincode(Object ZeroConfSupport.buildServiceInfoVersion3(..)) 
		&& call(Object Method.invoke(..));

	after() throwing(Exception e) : onInvoke() {
		if (e instanceof IllegalAccessException || e instanceof InvocationTargetException) {
			LogLog.warn("Unable to invoke create method", e);
		}
	}

	after() returning(Object r) : onInvoke() {
		LogLog.debug("created serviceinfo: " + r);
	}

	/* 
	 * Method createJmDNSVersion1
	 */

	pointcut onNewInstance2() : withincode(Object ZeroConfSupport.createJmDNSVersion1(..)) 
		&& call(Object Class.newInstance(..));

	after() throwing(Exception e) : onNewInstance2() {
		if (e instanceof InstantiationException || e instanceof IllegalAccessException) {
			LogLog.warn("Unable to instantiate JMDNS", e); 
		}
	}

	/*
	 *  createJmDNSVersion3
	 */

	pointcut onGetMethod2() : withincode(Object ZeroConfSupport.createJmDNSVersion3(..))
		&& call(Method Class.getMethod(..));

	after() throwing(NoSuchMethodException e) : onGetMethod2() {
		LogLog.warn("Unable to access constructor", e);	
	}

	pointcut onInvoke2() : withincode(Object ZeroConfSupport.createJmDNSVersion3(..)) 
		&& call(Object Method.invoke(..));

	after() throwing(Exception e) : onInvoke2() {
		if (e instanceof IllegalAccessException) {
			LogLog.warn("Unable to instantiate jmdns class", e);
		} else if (e instanceof InvocationTargetException) {
			LogLog.warn("Unable to call constructor", e);
		}
	}

	/*
	 * advertise
	 */

	pointcut onGetMethod3() : withincode(void ZeroConfSupport.advertise(..))
		&& call(Method Class.getMethod(..));

	after() throwing(NoSuchMethodException e) : onGetMethod3() {
		LogLog.warn("No registerService method", e);
	}

	pointcut onInvoke3() : withincode(void ZeroConfSupport.advertise(..)) 
		&& call(Object Method.invoke(..));

	after() throwing(Exception e) : onInvoke3() {
		if (e instanceof IllegalAccessException || e instanceof InvocationTargetException || e instanceof NullPointerException) {
			LogLog.warn("Unable to invoke registerService method", e);
		}
	}

	after() returning(Object r) : onInvoke3() {
		LogLog.debug("registered serviceInfo: " + r);
	}

	/*
	 * unadvertise
	 */

	pointcut onGetMethod4() : withincode(void ZeroConfSupport.unadvertise(..))
		&& call(Method Class.getMethod(..));

	after() throwing(NoSuchMethodException e) : onGetMethod4() {
		LogLog.warn("No unregisterService method", e);
	}

	pointcut onInvoke4() : withincode(void ZeroConfSupport.unadvertise(..)) 
		&& call(Object Method.invoke(..));

	after() throwing(Exception e) : onInvoke4() {
		if (e instanceof IllegalAccessException || e instanceof InvocationTargetException) {
			LogLog.warn("Unable to invoke unregisterService method", e);
		}
	}

	after() returning(Object r) : onInvoke4() {
		LogLog.debug("unregistered serviceInfo: " + r);
	}

	/*
	 * initializeJMDNS
	 */

	pointcut onForName() : withincode(Object ZeroConfSupport.initializeJMDNS(..))
		&& call(Class Class.forName(..));

	after() throwing(ClassNotFoundException e) : onForName() {
		LogLog.warn("JmDNS or serviceInfo class not found", e);
	}	
}