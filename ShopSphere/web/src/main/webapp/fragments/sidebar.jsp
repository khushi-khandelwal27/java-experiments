<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="col-lg-2 col-md-3 p-0 bg-dark admin-sidebar d-none d-md-block">
    <div class="p-3">
        <div class="d-flex align-items-center gap-2 mb-4 px-2 text-white">
            <i class="bi bi-shield-lock-fill fs-4 text-primary"></i>
            <span class="fs-5 fw-bold">Admin Portal</span>
        </div>
        <nav class="nav flex-column">
            <a class="nav-link ${pageContext.request.requestURI.endsWith('dashboard') || pageContext.request.requestURI.endsWith('dashboard.jsp') ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="bi bi-speedometer2 me-2"></i>Dashboard
            </a>
            <a class="nav-link ${pageContext.request.requestURI.contains('products') ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/admin/products">
                <i class="bi bi-box-seam me-2"></i>Products
            </a>
            <a class="nav-link ${pageContext.request.requestURI.contains('categories') ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/admin/categories">
                <i class="bi bi-tags me-2"></i>Categories
            </a>
            <a class="nav-link ${pageContext.request.requestURI.contains('orders') ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/admin/orders">
                <i class="bi bi-receipt me-2"></i>Customer Orders
            </a>
            <a class="nav-link ${pageContext.request.requestURI.contains('users') ? 'active' : ''}" 
               href="${pageContext.request.contextPath}/admin/users">
                <i class="bi bi-people me-2"></i>Users & Roles
            </a>
            <hr class="border-secondary opacity-25 my-3">
            <a class="nav-link" href="${pageContext.request.contextPath}/products" target="_blank">
                <i class="bi bi-box-arrow-up-right me-2"></i>View Storefront
            </a>
            <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                <i class="bi bi-box-arrow-left me-2"></i>Sign Out
            </a>
        </nav>
    </div>
</div>
