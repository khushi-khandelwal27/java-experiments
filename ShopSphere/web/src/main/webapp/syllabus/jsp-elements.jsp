<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="JSP Elements & Lifecycle - RTU Syllabus Demo" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<%!
    // 1. JSP DECLARATION TAG: Declares instance variables and methods inside the generated Servlet class
    private int pageHitCounter = 0;

    public synchronized int incrementHitCounter() {
        return ++pageHitCounter;
    }

    public String getAcademicHeading(String topic) {
        return "RTU Syllabus Demonstration: " + topic;
    }
%>

<%
    // 2. JSP SCRIPTLET TAG: Code placed inside the _jspService() method
    int currentHits = incrementHitCounter();
    String studentName = "Advanced Java Lab Student";
    String serverTime = new java.util.Date().toString();
%>

<%-- 3. JSP COMMENT TAG: Ignored by servlet engine and not transmitted to the browser --%>

<main class="py-5">
    <div class="container">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb small">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                <li class="breadcrumb-item active">Syllabus Demo: JSP Lifecycle & Scripting Elements</li>
            </ol>
        </nav>

        <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
            <div class="d-flex align-items-center gap-3 mb-3">
                <div class="p-3 bg-primary-subtle text-primary rounded-3 fs-3">
                    <i class="bi bi-filetype-html"></i>
                </div>
                <div>
                    <h2 class="fw-bold mb-0">JSP Architecture & Scripting Elements</h2>
                    <p class="text-muted mb-0">RTU Syllabus Topic: Declarations, Scriptlets, Expressions, Comments & Lifecycle</p>
                </div>
            </div>

            <hr class="my-4">

            <!-- Demonstration Output -->
            <div class="row g-4">
                <div class="col-md-6">
                    <div class="card bg-light border-0 rounded-3 p-3">
                        <h6 class="fw-bold text-primary"><i class="bi bi-gear-fill me-2"></i>Live Evaluated Results:</h6>
                        <ul class="list-group list-group-flush bg-transparent small">
                            <li class="list-group-item bg-transparent">
                                <strong>Declaration Output (Method):</strong> <%= getAcademicHeading("JSP Lifecycle") %>
                            </li>
                            <li class="list-group-item bg-transparent">
                                <strong>Declaration Counter:</strong> Cumulative page hits = <span class="badge bg-primary"><%= currentHits %></span>
                            </li>
                            <li class="list-group-item bg-transparent">
                                <strong>Scriptlet Variable:</strong> Student Name = <%= studentName %>
                            </li>
                            <li class="list-group-item bg-transparent">
                                <strong>Expression Output:</strong> Server Timestamp = <%= serverTime %>
                            </li>
                            <li class="list-group-item bg-transparent">
                                <strong>Expression Language (EL):</strong> App Name = ${applicationScope.appName}
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card bg-dark text-light border-0 rounded-3 p-3 small font-monospace">
                        <div class="text-warning fw-bold mb-2">Code Syntax Shown in Viva:</div>
<pre class="mb-0 text-white"><code><span class="text-secondary">&lt;%-- JSP Declaration --%&gt;</span>
&lt;%! int counter = 0; %&gt;

<span class="text-secondary">&lt;%-- JSP Scriptlet --%&gt;</span>
&lt;% String msg = "Hello RTU"; %&gt;

<span class="text-secondary">&lt;%-- JSP Expression --%&gt;</span>
&lt;%= msg %&gt;

<span class="text-secondary">&lt;%-- Modern JSP EL --%&gt;</span>
\${product.price}
</code></pre>
                    </div>
                </div>
            </div>

            <!-- JSP Lifecycle Diagram -->
            <div class="mt-5">
                <h5 class="fw-bold mb-3">JSP Lifecycle Stages</h5>
                <div class="row g-3 text-center">
                    <div class="col-md-2 col-4">
                        <div class="p-3 border rounded-3 bg-light">
                            <strong class="small d-block text-primary">1. Translation</strong>
                            <small class="text-muted">.jsp &rarr; .java</small>
                        </div>
                    </div>
                    <div class="col-md-2 col-4">
                        <div class="p-3 border rounded-3 bg-light">
                            <strong class="small d-block text-primary">2. Compilation</strong>
                            <small class="text-muted">.java &rarr; .class</small>
                        </div>
                    </div>
                    <div class="col-md-2 col-4">
                        <div class="p-3 border rounded-3 bg-light">
                            <strong class="small d-block text-primary">3. Loading</strong>
                            <small class="text-muted">Class loading</small>
                        </div>
                    </div>
                    <div class="col-md-2 col-4">
                        <div class="p-3 border rounded-3 bg-light">
                            <strong class="small d-block text-primary">4. Instantiation</strong>
                            <small class="text-muted">jspInit()</small>
                        </div>
                    </div>
                    <div class="col-md-2 col-4">
                        <div class="p-3 border rounded-3 bg-light">
                            <strong class="small d-block text-primary">5. Execution</strong>
                            <small class="text-muted">_jspService()</small>
                        </div>
                    </div>
                    <div class="col-md-2 col-4">
                        <div class="p-3 border rounded-3 bg-light">
                            <strong class="small d-block text-primary">6. Cleanup</strong>
                            <small class="text-muted">jspDestroy()</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/fragments/footer.jsp" %>
