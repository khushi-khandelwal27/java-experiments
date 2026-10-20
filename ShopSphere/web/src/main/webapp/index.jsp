<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="ShopSphere - Ultimate E-Commerce Storefront" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<main class="py-4">
    <div class="container">
        <!-- Hero Banner -->
        <div class="hero-banner mb-5 shadow-lg">
            <div class="row align-items-center">
                <div class="col-lg-7 py-4">
                    <span class="badge bg-primary text-uppercase px-3 py-2 mb-3 rounded-pill fw-bold">Next-Gen Shopping Experience</span>
                    <h1 class="display-4 fw-extrabold text-white mb-3" style="letter-spacing: -1px;">
                        Curated Tech, Fashion & Modern Lifestyle
                    </h1>
                    <p class="lead text-light opacity-75 mb-4">
                        Discover industry-leading electronics, stylish apparel, and home essentials with verified quality and lightning-fast delivery.
                    </p>
                    <div class="d-flex flex-wrap gap-3">
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary btn-lg rounded-pill px-4 shadow">
                            <i class="bi bi-compass me-2"></i>Explore Catalog
                        </a>
                        <a href="${pageContext.request.contextPath}/products?sort=discount" class="btn btn-outline-light btn-lg rounded-pill px-4">
                            <i class="bi bi-tag me-2"></i>Hot Deals
                        </a>
                    </div>
                </div>
                <div class="col-lg-5 text-center d-none d-lg-block">
                    <img src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500" 
                         alt="Featured Product" class="img-fluid rounded-4 shadow-lg" style="max-height: 320px; object-fit: cover;">
                </div>
            </div>
        </div>

        <!-- Category Showcase -->
        <div class="mb-5">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h3 class="fw-bold mb-0">Browse by Category</h3>
                <a href="${pageContext.request.contextPath}/products" class="text-primary text-decoration-none fw-semibold">
                    View All <i class="bi bi-arrow-right"></i>
                </a>
            </div>
            <div class="row row-cols-2 row-cols-md-3 row-cols-lg-5 g-3">
                <c:forEach var="cat" items="${applicationScope.globalCategories}">
                    <div class="col">
                        <a href="${pageContext.request.contextPath}/products?category=${cat.categoryId}" class="text-decoration-none">
                            <div class="card h-100 border-0 shadow-sm text-center p-3 rounded-4 hover-shadow transition">
                                <div class="mx-auto mb-2 text-primary fs-2">
                                    <c:choose>
                                        <c:when test="${cat.name.contains('Electronics')}"><i class="bi bi-laptop"></i></c:when>
                                        <c:when test="${cat.name.contains('Fashion')}"><i class="bi bi-handbag"></i></c:when>
                                        <c:when test="${cat.name.contains('Kitchen')}"><i class="bi bi-house-door"></i></c:when>
                                        <c:when test="${cat.name.contains('Books')}"><i class="bi bi-book"></i></c:when>
                                        <c:otherwise><i class="bi bi-activity"></i></c:otherwise>
                                    </c:choose>
                                </div>
                                <h6 class="fw-bold text-dark mb-1">${cat.name}</h6>
                                <p class="text-muted small mb-0 text-truncate">${cat.description}</p>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Value Propositions -->
        <div class="row g-4 mb-5">
            <div class="col-md-3 col-sm-6">
                <div class="d-flex align-items-center gap-3 p-3 bg-white rounded-3 shadow-sm border border-light">
                    <i class="bi bi-truck fs-1 text-primary"></i>
                    <div>
                        <h6 class="fw-bold mb-0">Free Shipping</h6>
                        <small class="text-muted">On orders above ₹500</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="d-flex align-items-center gap-3 p-3 bg-white rounded-3 shadow-sm border border-light">
                    <i class="bi bi-shield-check fs-1 text-success"></i>
                    <div>
                        <h6 class="fw-bold mb-0">Secure Payments</h6>
                        <small class="text-muted">Cards, UPI & COD</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="d-flex align-items-center gap-3 p-3 bg-white rounded-3 shadow-sm border border-light">
                    <i class="bi bi-arrow-repeat fs-1 text-warning"></i>
                    <div>
                        <h6 class="fw-bold mb-0">Easy 7-Day Returns</h6>
                        <small class="text-muted">Hassle-free guarantee</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3 col-sm-6">
                <div class="d-flex align-items-center gap-3 p-3 bg-white rounded-3 shadow-sm border border-light">
                    <i class="bi bi-headset fs-1 text-info"></i>
                    <div>
                        <h6 class="fw-bold mb-0">24/7 Support</h6>
                        <small class="text-muted">Dedicated assistance</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- RTU Project Syllabus Highlight Box -->
        <div class="card border-primary bg-primary-subtle p-4 rounded-4 mb-5 shadow-sm">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h4 class="fw-bold text-primary mb-2"><i class="bi bi-award-fill me-2"></i>RTU Advanced Java Capstone Project</h4>
                    <p class="text-secondary mb-0">
                        This system implements MVC architecture, Jakarta Servlets, JSP fragments & tag files, custom filters, listeners, JDBC transactions, Java RMI inventory service, java.net Socket client-server, and Java Swing admin desktop client.
                    </p>
                </div>
                <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                    <a href="${pageContext.request.contextPath}/syllabus/jsp-elements.jsp" class="btn btn-primary rounded-pill px-3 py-2 fw-semibold">
                        <i class="bi bi-play-circle me-1"></i>Explore Syllabus Demos
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/fragments/footer.jsp" %>
