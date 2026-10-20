<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="My Orders - ShopSphere" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <h2 class="fw-bold mb-4 d-flex align-items-center gap-2">
            <i class="bi bi-box-seam text-primary"></i> Order History & Tracking
        </h2>

        <c:choose>
            <c:when test="${not empty orders && orders.size() > 0}">
                <div class="d-flex flex-column gap-3">
                    <c:forEach var="ord" items="${orders}">
                        <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                            <div class="card-header bg-light border-0 py-3 px-4 d-flex flex-wrap justify-content-between align-items-center gap-3">
                                <div>
                                    <span class="text-muted small">Order ID:</span>
                                    <strong class="text-primary ms-1">#SPH-${ord.orderId}</strong>
                                    <span class="text-muted small ms-3">Placed on:</span>
                                    <span class="small fw-semibold ms-1"><fmt:formatDate value="${ord.createdAt}" pattern="dd MMM yyyy, hh:mm a"/></span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <c:choose>
                                        <c:when test="${ord.orderStatus == 'PLACED'}"><span class="badge badge-status badge-placed">Placed</span></c:when>
                                        <c:when test="${ord.orderStatus == 'PROCESSING'}"><span class="badge badge-status badge-processing">Processing</span></c:when>
                                        <c:when test="${ord.orderStatus == 'SHIPPED'}"><span class="badge badge-status badge-shipped">Shipped</span></c:when>
                                        <c:when test="${ord.orderStatus == 'DELIVERED'}"><span class="badge badge-status badge-delivered">Delivered</span></c:when>
                                        <c:otherwise><span class="badge badge-status badge-cancelled">Cancelled</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="card-body p-4">
                                <div class="row align-items-center">
                                    <div class="col-md-7">
                                        <div class="d-flex flex-column gap-2">
                                            <c:forEach var="item" items="${ord.items}">
                                                <div class="d-flex align-items-center gap-3">
                                                    <img src="${item.product.imageUrl}" alt="${item.product.name}" 
                                                         class="rounded-3" style="width: 50px; height: 50px; object-fit: cover;">
                                                    <div>
                                                        <h6 class="mb-0 fw-bold small text-dark">${item.product.name}</h6>
                                                        <small class="text-muted">Qty: ${item.quantity} &times; ₹<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></small>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="col-md-5 text-md-end mt-3 mt-md-0">
                                        <div class="small text-muted mb-1">Total Paid via ${ord.paymentMethod}:</div>
                                        <div class="fs-4 fw-extrabold text-dark mb-3">₹<fmt:formatNumber value="${ord.totalAmount}" pattern="#,##0.00"/></div>
                                        <a href="${pageContext.request.contextPath}/order-details?id=${ord.orderId}" 
                                           class="btn btn-outline-primary btn-sm rounded-pill px-3">
                                            <i class="bi bi-geo-alt me-1"></i>Track Details
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white my-4">
                    <div class="display-3 text-muted mb-3"><i class="bi bi-bag-x"></i></div>
                    <h3 class="fw-bold">No Orders Placed Yet</h3>
                    <p class="text-muted mb-4">When you place an order, its real-time shipping timeline and history will appear here.</p>
                    <div>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-4 py-2">
                            Explore Catalog
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<%@ include file="/fragments/footer.jsp" %>
