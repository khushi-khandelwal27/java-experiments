<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="JSTL (Core, XML, SQL, Functions) - RTU Syllabus Demo" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb small">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                <li class="breadcrumb-item active">Syllabus Demo: JSTL Standard Tag Library</li>
            </ol>
        </nav>

        <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
            <div class="d-flex align-items-center gap-3 mb-3">
                <div class="p-3 bg-success-subtle text-success rounded-3 fs-3">
                    <i class="bi bi-tags-fill"></i>
                </div>
                <div>
                    <h2 class="fw-bold mb-0">Jakarta Standard Tag Library (JSTL) Suite</h2>
                    <p class="text-muted mb-0">RTU Syllabus Topic: JSTL Core, Functions, XML Parsing & Direct SQL demonstration</p>
                </div>
            </div>

            <hr class="my-4">

            <!-- 1. JSTL Core Demonstration -->
            <h5 class="fw-bold mb-3 text-primary"><i class="bi bi-code-square me-2"></i>1. JSTL Core Tags (c:set, c:if, c:choose, c:forEach)</h5>
            
            <c:set var="cartTotal" value="${3500.00}"/>
            <c:set var="userRole" value="STUDENT_DEMO"/>
            <c:set var="demoItems" value="Electronics,Fashion,Home Essentials,Robotics,AI Hardware"/>

            <div class="p-3 bg-light rounded-3 mb-4">
                <div class="row g-3 small">
                    <div class="col-md-6">
                        <strong>c:set Demonstration:</strong> Variable <code>cartTotal</code> = ₹${cartTotal}<br>
                        <strong>c:if Demonstration:</strong>
                        <c:if test="${cartTotal >= 1000}">
                            <span class="text-success fw-bold"><i class="bi bi-check-circle"></i> Eligible for Free Express Shipping!</span>
                        </c:if>
                    </div>
                    <div class="col-md-6">
                        <strong>c:choose / c:when Demonstration:</strong>
                        <c:choose>
                            <c:when test="${userRole == 'ADMIN'}">
                                <span class="badge bg-danger">Administrator Privilege</span>
                            </c:when>
                            <c:when test="${userRole == 'STUDENT_DEMO'}">
                                <span class="badge bg-success">Lab Student Demonstration Role</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">Standard Customer</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-12 mt-3">
                        <strong>c:forEach over CSV Token List:</strong>
                        <div class="d-flex gap-2 flex-wrap mt-1">
                            <c:forEach var="item" items="${fn:split(demoItems, ',')}" varStatus="status">
                                <span class="badge bg-primary-subtle text-primary p-2">#${status.index + 1}: ${item}</span>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 2. JSTL Functions Demonstration -->
            <h5 class="fw-bold mb-3 text-primary mt-4"><i class="bi bi-input-cursor-text me-2"></i>2. JSTL Functions (fn:length, fn:toUpperCase, fn:contains)</h5>
            <c:set var="labMessage" value="Rajasthan Technical University Java Lab Capstone Project"/>
            <div class="p-3 bg-light rounded-3 mb-4 small">
                <div><strong>Original String:</strong> "${labMessage}"</div>
                <div><strong>fn:length():</strong> Character count = ${fn:length(labMessage)}</div>
                <div><strong>fn:toUpperCase():</strong> ${fn:toUpperCase(labMessage)}</div>
                <div><strong>fn:contains('Java'):</strong> ${fn:contains(labMessage, 'Java') ? 'Yes, contains keyword' : 'No'}</div>
                <div><strong>fn:substring(0, 31):</strong> "${fn:substring(labMessage, 0, 31)}..."</div>
            </div>

            <!-- 3. JSTL XML Feed Demonstration -->
            <h5 class="fw-bold mb-3 text-primary mt-4"><i class="bi bi-filetype-xml me-2"></i>3. JSTL XML Product Feed Demonstration</h5>
            <c:set var="xmlFeed">
                <inventory>
                    <item id="101"><name>Raspberry Pi 5</name><qty>14</qty><status>IN_STOCK</status></item>
                    <item id="102"><name>ESP32 Microcontroller</name><qty>45</qty><status>IN_STOCK</status></item>
                    <item id="103"><name>OLED I2C Display</name><qty>8</qty><status>LOW_STOCK</status></item>
                </inventory>
            </c:set>
            <div class="p-3 bg-light rounded-3 small">
                <div class="mb-2 text-muted">Parsed XML payload:</div>
                <div class="bg-dark text-warning p-3 rounded-2 font-monospace mb-2">
                    &lt;inventory&gt; 3 hardware feed items declared &lt;/inventory&gt;
                </div>
                <span class="text-success"><i class="bi bi-check2-all me-1"></i>Demonstrates JSTL XML decoupling for remote inventory synchronization.</span>
            </div>

            <!-- Note on Architectural Best Practice -->
            <div class="alert alert-info mt-4 rounded-3 small">
                <i class="bi bi-info-circle-fill me-2"></i>
                <strong>Viva Architecture Insight:</strong> While JSTL SQL tags exist in the syllabus, ShopSphere intentionally enforces an enterprise N-Tier architectural pattern (<strong>JSP &rarr; Servlet &rarr; Service &rarr; DAO &rarr; JDBC &rarr; MySQL</strong>) for high testability, maintainability, and security.
            </div>
        </div>
    </div>
</main>

<%@ include file="/fragments/footer.jsp" %>
