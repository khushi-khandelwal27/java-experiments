<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Order Confirmation - ShopSphere" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<main class="py-5 bg-light d-flex align-items-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-9 col-lg-7">
                <div class="card border-0 shadow-lg rounded-4 text-center p-4 p-md-5 bg-white">
                    <div class="mb-3">
                        <div class="d-inline-flex align-items-center justify-content-center rounded-circle bg-success text-white shadow-sm" style="width: 80px; height: 80px;">
                            <i class="bi bi-check-lg display-4"></i>
                        </div>
                    </div>

                    <h2 class="fw-bold mb-2">Order Confirmed!</h2>
                    <p class="text-muted mb-4">
                        Thank you for your purchase with ShopSphere. Your payment authorization and order registration are verified.
                    </p>

                    <div class="row g-2 justify-content-center mb-4">
                        <div class="col-sm-6">
                            <div class="p-3 bg-light rounded-3 text-start border">
                                <div class="small text-muted">Order Reference:</div>
                                <div class="fs-5 fw-extrabold text-primary font-monospace">#SPH-${param.orderId != null ? param.orderId : '101'}</div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="p-3 bg-light rounded-3 text-start border">
                                <div class="small text-muted">Estimated Delivery:</div>
                                <div class="fs-6 fw-bold text-dark"><i class="bi bi-truck text-success me-1"></i>Within 2 - 4 Business Days</div>
                            </div>
                        </div>
                    </div>

                    <!-- Action buttons -->
                    <div class="d-flex justify-content-center gap-3 flex-wrap">
                        <a href="${pageContext.request.contextPath}/invoice?orderId=${param.orderId}" class="btn btn-outline-primary rounded-pill px-4 py-2 fw-semibold">
                            <i class="bi bi-receipt me-1"></i> View Tax Invoice
                        </a>
                        <a href="${pageContext.request.contextPath}/order-details?id=${param.orderId}" class="btn btn-shopsphere rounded-pill px-4 py-2 fw-semibold shadow-sm">
                            <i class="bi bi-geo-alt-fill me-1"></i> Track My Shipment
                        </a>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-light border rounded-pill px-4 py-2">
                            <i class="bi bi-bag me-1"></i> Continue Shopping
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/fragments/footer.jsp" %>
