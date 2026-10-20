<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Internationalization (i18n) - RTU Syllabus Demo" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<%
    String lang = request.getParameter("lang");
    if (lang != null && !lang.trim().isEmpty()) {
        session.setAttribute("currentLocale", lang);
    }
    String currentLocale = (String) session.getAttribute("currentLocale");
    if (currentLocale == null) {
        currentLocale = "en";
    }
%>

<fmt:setLocale value="<%= currentLocale %>"/>
<fmt:setBundle basename="messages"/>

<main class="py-5">
    <div class="container">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb small">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                <li class="breadcrumb-item active">Syllabus Demo: Internationalization (i18n)</li>
            </ol>
        </nav>

        <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-3 mb-3">
                <div class="d-flex align-items-center gap-3">
                    <div class="p-3 bg-warning-subtle text-warning-emphasis rounded-3 fs-3">
                        <i class="bi bi-translate"></i>
                    </div>
                    <div>
                        <h2 class="fw-bold mb-0">Internationalization & Localization (i18n)</h2>
                        <p class="text-muted mb-0">RTU Syllabus Topic: Locale, ResourceBundle, fmt:message & Date/Currency formatting</p>
                    </div>
                </div>

                <!-- Locale Switcher Buttons -->
                <div class="btn-group shadow-sm rounded-pill overflow-hidden">
                    <a href="?lang=en" class="btn btn-sm <%= "en".equals(currentLocale) ? "btn-primary" : "btn-outline-primary" %> px-3">
                        English (en_IN)
                    </a>
                    <a href="?lang=hi" class="btn btn-sm <%= "hi".equals(currentLocale) ? "btn-primary" : "btn-outline-primary" %> px-3">
                        हिन्दी (hi_IN)
                    </a>
                </div>
            </div>

            <hr class="my-4">

            <!-- Active Resource Bundle Strings -->
            <div class="row g-4">
                <div class="col-md-6">
                    <div class="card bg-light border-0 rounded-4 p-4 h-100">
                        <h5 class="fw-bold text-primary mb-3">
                            <i class="bi bi-chat-quote-fill me-2"></i>ResourceBundle Values (<%= currentLocale.toUpperCase() %>):
                        </h5>
                        <ul class="list-group list-group-flush bg-transparent small">
                            <li class="list-group-item bg-transparent d-flex justify-content-between">
                                <span class="text-muted">app.title:</span>
                                <strong><fmt:message key="app.title"/></strong>
                            </li>
                            <li class="list-group-item bg-transparent d-flex justify-content-between">
                                <span class="text-muted">app.tagline:</span>
                                <strong><fmt:message key="app.tagline"/></strong>
                            </li>
                            <li class="list-group-item bg-transparent d-flex justify-content-between">
                                <span class="text-muted">btn.addToCart:</span>
                                <span class="badge bg-primary fs-6"><fmt:message key="btn.addToCart"/></span>
                            </li>
                            <li class="list-group-item bg-transparent d-flex justify-content-between">
                                <span class="text-muted">btn.placeOrder:</span>
                                <span class="badge bg-success fs-6"><fmt:message key="btn.placeOrder"/></span>
                            </li>
                            <li class="list-group-item bg-transparent d-flex justify-content-between">
                                <span class="text-muted">lbl.shipping:</span>
                                <strong><fmt:message key="lbl.shipping"/></strong>
                            </li>
                            <li class="list-group-item bg-transparent d-flex justify-content-between">
                                <span class="text-muted">lbl.warranty:</span>
                                <strong><fmt:message key="lbl.warranty"/></strong>
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Formatted Dates and Numbers -->
                <div class="col-md-6">
                    <div class="card bg-light border-0 rounded-4 p-4 h-100">
                        <h5 class="fw-bold text-success mb-3">
                            <i class="bi bi-calendar2-date me-2"></i>Locale-Aware Date & Currency Formatting:
                        </h5>
                        <c:set var="sampleAmount" value="129999.50"/>
                        <jsp:useBean id="currentTimestamp" class="java.util.Date"/>

                        <ul class="list-group list-group-flush bg-transparent small">
                            <li class="list-group-item bg-transparent">
                                <strong>Raw Numeric Amount:</strong> ${sampleAmount}
                            </li>
                            <li class="list-group-item bg-transparent">
                                <strong>Formatted Currency (fmt:formatNumber):</strong>
                                <span class="fs-5 fw-bold text-dark ms-2">
                                    ₹<fmt:formatNumber value="${sampleAmount}" type="currency" currencySymbol="₹" maxFractionDigits="2"/>
                                </span>
                            </li>
                            <li class="list-group-item bg-transparent">
                                <strong>Date (Full Style):</strong>
                                <span class="ms-2 fw-semibold">
                                    <fmt:formatDate value="${currentTimestamp}" type="date" dateStyle="full"/>
                                </span>
                            </li>
                            <li class="list-group-item bg-transparent">
                                <strong>Time (Full Style):</strong>
                                <span class="ms-2 fw-semibold">
                                    <fmt:formatDate value="${currentTimestamp}" type="time" timeStyle="medium"/>
                                </span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Java Code Viva Explanation -->
            <div class="card bg-dark text-white rounded-4 p-4 mt-4 font-monospace small">
                <div class="text-warning fw-bold mb-2">Java Backend Viva Snippet:</div>
<pre class="mb-0 text-white"><code>Locale hindiLocale = new Locale("hi", "IN");
ResourceBundle bundle = ResourceBundle.getBundle("messages", hindiLocale);
String appTitle = bundle.getString("app.title"); // Returns "शॉपस्फेयर - प्रीमियम ई-कॉमर्स"

NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(hindiLocale);
String formattedPrice = currencyFormatter.format(129999.50);
</code></pre>
            </div>
        </div>
    </div>
</main>

<%@ include file="/fragments/footer.jsp" %>
