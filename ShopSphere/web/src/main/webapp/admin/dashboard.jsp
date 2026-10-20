<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Admin Dashboard - ShopSphere Management" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<div class="container-fluid">
    <div class="row">
        <%@ include file="/fragments/sidebar.jsp" %>

        <main class="col-lg-10 col-md-9 ms-sm-auto px-md-4 py-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-2 pb-3 mb-4 border-bottom">
                <h2 class="h3 fw-bold mb-0">Executive Dashboard</h2>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <span class="badge bg-primary-subtle text-primary p-2 rounded-pill fw-semibold">
                        <i class="bi bi-person-badge me-1"></i>Admin: ${sessionScope.user.name}
                    </span>
                </div>
            </div>

            <!-- Metric Cards -->
            <div class="row g-3 mb-4">
                <div class="col-xl-3 col-sm-6">
                    <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <small class="text-muted fw-bold text-uppercase">Total Sales</small>
                                <h3 class="fw-extrabold text-primary mb-0 mt-1">₹<fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/></h3>
                            </div>
                            <div class="p-3 bg-primary-subtle text-primary rounded-circle fs-4">
                                <i class="bi bi-currency-rupee"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-sm-6">
                    <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <small class="text-muted fw-bold text-uppercase">Total Orders</small>
                                <h3 class="fw-extrabold text-dark mb-0 mt-1">${totalOrders}</h3>
                            </div>
                            <div class="p-3 bg-success-subtle text-success rounded-circle fs-4">
                                <i class="bi bi-cart-check"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-sm-6">
                    <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <small class="text-muted fw-bold text-uppercase">Active Catalog</small>
                                <h3 class="fw-extrabold text-dark mb-0 mt-1">${totalProducts}</h3>
                            </div>
                            <div class="p-3 bg-warning-subtle text-warning rounded-circle fs-4">
                                <i class="bi bi-boxes"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-3 col-sm-6">
                    <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <small class="text-muted fw-bold text-uppercase">Registered Users</small>
                                <h3 class="fw-extrabold text-dark mb-0 mt-1">${totalUsers}</h3>
                            </div>
                            <div class="p-3 bg-info-subtle text-info rounded-circle fs-4">
                                <i class="bi bi-people"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Low Stock Warnings & Recent Orders -->
            <div class="row g-4 mb-4">
                <!-- Low-Stock Alerts -->
                <div class="col-lg-5">
                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white h-100">
                        <div class="card-header bg-white py-3 px-4 fw-bold d-flex justify-content-between align-items-center">
                            <span><i class="bi bi-exclamation-triangle-fill text-danger me-2"></i>Low Stock Inventory Alert</span>
                            <span class="badge bg-danger">${lowStockProducts.size()} Items</span>
                        </div>
                        <div class="table-responsive">
                            <table class="table align-middle mb-0 small">
                                <thead class="bg-light">
                                    <tr>
                                        <th class="ps-4">Product</th>
                                        <th>Stock</th>
                                        <th class="pe-4 text-end">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${lowStockProducts}">
                                        <tr>
                                            <td class="ps-4">
                                                <strong>${p.name}</strong><br>
                                                <small class="text-muted">${p.brand}</small>
                                            </td>
                                            <td>
                                                <span class="badge bg-danger-subtle text-danger fw-bold">${p.stock} units</span>
                                            </td>
                                            <td class="pe-4 text-end">
                                                <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.productId}" class="btn btn-outline-primary btn-sm rounded-pill">
                                                    Restock
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Recent Orders Table -->
                <div class="col-lg-7">
                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white h-100">
                        <div class="card-header bg-white py-3 px-4 fw-bold d-flex justify-content-between align-items-center">
                            <span><i class="bi bi-clock-history text-primary me-2"></i>Recent Customer Orders</span>
                            <a href="${pageContext.request.contextPath}/admin/orders" class="small text-primary text-decoration-none">View All</a>
                        </div>
                        <div class="table-responsive">
                            <table class="table align-middle mb-0 small">
                                <thead class="bg-light">
                                    <tr>
                                        <th class="ps-4">Order ID</th>
                                        <th>Customer</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="ord" items="${recentOrders}">
                                        <tr>
                                            <td class="ps-4">
                                                <a href="${pageContext.request.contextPath}/order-details?id=${ord.orderId}" class="fw-bold text-decoration-none">
                                                    #SPH-${ord.orderId}
                                                </a>
                                            </td>
                                            <td>${ord.userName}</td>
                                            <td class="fw-bold">₹<fmt:formatNumber value="${ord.totalAmount}" pattern="#,##0.00"/></td>
                                            <td>
                                                <span class="badge badge-status badge-${ord.orderStatus.toLowerCase()}">${ord.orderStatus}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<%@ include file="/fragments/footer.jsp" %>
