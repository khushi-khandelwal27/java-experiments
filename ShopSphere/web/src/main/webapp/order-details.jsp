<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Order #SPH-${order.orderId} Details - ShopSphere" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<main class="py-5 bg-light">
    <div class="container">
        <!-- Back and title -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="${pageContext.request.contextPath}/orders" class="small text-muted text-decoration-none">
                    <i class="bi bi-arrow-left me-1"></i>Back to My Orders
                </a>
                <h3 class="fw-bold mt-1 mb-0">Order Tracking: #SPH-${order.orderId}</h3>
            </div>
            <div class="d-flex align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/invoice?orderId=${order.orderId}" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                    <i class="bi bi-file-earmark-text me-1"></i>Tax Invoice
                </a>
                <c:choose>
                    <c:when test="${order.orderStatus == 'PLACED'}"><span class="badge badge-status badge-placed fs-6">Placed</span></c:when>
                    <c:when test="${order.orderStatus == 'PROCESSING'}"><span class="badge badge-status badge-processing fs-6">Processing</span></c:when>
                    <c:when test="${order.orderStatus == 'SHIPPED'}"><span class="badge badge-status badge-shipped fs-6">Shipped</span></c:when>
                    <c:when test="${order.orderStatus == 'DELIVERED'}"><span class="badge badge-status badge-delivered fs-6">Delivered</span></c:when>
                    <c:otherwise><span class="badge badge-status badge-cancelled fs-6">Cancelled</span></c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Visual Tracking Timeline -->
        <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
            <h5 class="fw-bold mb-4">Shipment Progress</h5>
            
            <div class="order-timeline">
                <!-- Step 1: Placed -->
                <div class="timeline-step ${order.orderStatus == 'PLACED' ? 'active' : 'completed'}">
                    <div class="step-icon"><i class="bi bi-check-lg"></i></div>
                    <div class="small fw-bold">Order Placed</div>
                    <div class="text-muted" style="font-size: 0.75rem;"><fmt:formatDate value="${order.createdAt}" pattern="dd MMM"/></div>
                </div>

                <!-- Step 2: Processing -->
                <div class="timeline-step ${order.orderStatus == 'PROCESSING' ? 'active' : (order.orderStatus == 'SHIPPED' || order.orderStatus == 'DELIVERED' ? 'completed' : '')}">
                    <div class="step-icon"><i class="bi bi-box-seam"></i></div>
                    <div class="small fw-bold">Processing</div>
                    <div class="text-muted" style="font-size: 0.75rem;">Fulfillment</div>
                </div>

                <!-- Step 3: Shipped -->
                <div class="timeline-step ${order.orderStatus == 'SHIPPED' ? 'active' : (order.orderStatus == 'DELIVERED' ? 'completed' : '')}">
                    <div class="step-icon"><i class="bi bi-truck"></i></div>
                    <div class="small fw-bold">Dispatched</div>
                    <div class="text-muted" style="font-size: 0.75rem;">On the way</div>
                </div>

                <!-- Step 4: Delivered -->
                <div class="timeline-step ${order.orderStatus == 'DELIVERED' ? 'completed active' : ''}">
                    <div class="step-icon"><i class="bi bi-house-check"></i></div>
                    <div class="small fw-bold">Delivered</div>
                    <div class="text-muted" style="font-size: 0.75rem;">Package received</div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Ordered Items List -->
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                    <div class="card-header bg-white py-3 px-4 fw-bold">
                        Items in this Shipment (${order.items.size()})
                    </div>
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead class="bg-light small text-secondary">
                                <tr>
                                    <th class="ps-4">Product</th>
                                    <th>Price</th>
                                    <th>Quantity</th>
                                    <th class="pe-4 text-end">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${order.items}">
                                    <tr>
                                        <td class="ps-4 py-3">
                                            <div class="d-flex align-items-center gap-3">
                                                <img src="${item.product.imageUrl}" alt="${item.product.name}" 
                                                     class="rounded-3 shadow-sm" style="width: 54px; height: 54px; object-fit: cover;">
                                                <div>
                                                    <a href="${pageContext.request.contextPath}/product-details?id=${item.productId}" 
                                                       class="fw-bold text-dark text-decoration-none small">
                                                        ${item.product.name}
                                                    </a>
                                                    <small class="d-block text-muted text-uppercase">${item.product.brand}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="small">₹<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
                                        <td class="small">${item.quantity}</td>
                                        <td class="pe-4 text-end fw-bold small text-primary">₹<fmt:formatNumber value="${item.subTotal}" pattern="#,##0.00"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Shipping & Payment Breakdown -->
            <div class="col-lg-4">
                <!-- Address info -->
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                    <h6 class="fw-bold mb-3"><i class="bi bi-geo-alt-fill text-primary me-2"></i>Shipping Address</h6>
                    <c:choose>
                        <c:when test="${not empty order.address}">
                            <div class="small">
                                <span class="badge bg-secondary mb-2">${order.address.addressType}</span><br>
                                <strong>${order.address.addressLine}</strong><br>
                                ${order.address.city}, ${order.address.state} - ${order.address.pincode}
                            </div>
                        </c:when>
                        <c:otherwise>
                            <span class="text-muted small">Standard Express Address</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Payment Details -->
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                    <h6 class="fw-bold mb-3"><i class="bi bi-credit-card text-success me-2"></i>Payment Summary</h6>
                    <div class="d-flex justify-content-between mb-2 small">
                        <span class="text-muted">Payment Method:</span>
                        <strong class="text-dark">${order.paymentMethod}</strong>
                    </div>
                    <div class="d-flex justify-content-between mb-2 small">
                        <span class="text-muted">Payment Status:</span>
                        <span class="badge ${order.paymentStatus == 'COMPLETED' ? 'bg-success-subtle text-success' : 'bg-warning-subtle text-warning'}">${order.paymentStatus}</span>
                    </div>
                    <c:if test="${not empty order.payment && not empty order.payment.transactionReference}">
                        <div class="d-flex justify-content-between mb-2 small">
                            <span class="text-muted">Txn Reference:</span>
                            <span class="font-monospace text-primary fw-semibold" style="font-size: 0.8rem;">${order.payment.transactionReference}</span>
                        </div>
                    </c:if>
                    <c:if test="${order.discount > 0}">
                        <div class="d-flex justify-content-between mb-2 small">
                            <span class="text-muted">Promo Discount:</span>
                            <span class="text-danger fw-bold">- ₹<fmt:formatNumber value="${order.discount}" pattern="#,##0.00"/></span>
                        </div>
                    </c:if>
                    <hr class="my-3">
                    <div class="d-flex justify-content-between mb-3">
                        <span class="fw-bold">Total Paid:</span>
                        <span class="fw-extrabold text-primary fs-5">₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                    </div>
                    <a href="${pageContext.request.contextPath}/invoice?orderId=${order.orderId}" class="btn btn-outline-secondary btn-sm w-100 rounded-pill">
                        <i class="bi bi-printer me-1"></i> View / Print Official Invoice
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/fragments/footer.jsp" %>
