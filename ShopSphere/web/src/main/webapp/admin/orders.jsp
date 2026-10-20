<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Order Processing & Tracking - ShopSphere Admin" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<div class="container-fluid">
    <div class="row">
        <%@ include file="/fragments/sidebar.jsp" %>

        <main class="col-lg-10 col-md-9 ms-sm-auto px-md-4 py-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-2 pb-3 mb-4 border-bottom">
                <h2 class="h3 fw-bold mb-0">Customer Orders & Fulfillment</h2>
            </div>

            <c:if test="${param.msg == 'status_updated'}">
                <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>Order status updated successfully! Customer tracking is refreshed.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                <div class="card-header bg-white py-3 px-4 fw-bold">
                    All Customer Transactions (${orders.size()})
                </div>
                <div class="table-responsive">
                    <table class="table align-middle mb-0 small">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4">Order ID</th>
                                <th>Customer</th>
                                <th>Date Placed</th>
                                <th>Amount</th>
                                <th>Payment</th>
                                <th>Status Pipeline</th>
                                <th class="pe-4 text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ord" items="${orders}">
                                <tr>
                                    <td class="ps-4 fw-bold text-primary">#SPH-${ord.orderId}</td>
                                    <td>
                                        <strong>${ord.userName}</strong><br>
                                        <small class="text-muted">${ord.userEmail}</small>
                                    </td>
                                    <td><fmt:formatDate value="${ord.createdAt}" pattern="dd MMM yyyy, hh:mm a"/></td>
                                    <td class="fw-bold">₹<fmt:formatNumber value="${ord.totalAmount}" pattern="#,##0.00"/></td>
                                    <td>
                                        <span class="badge bg-light text-dark border">${ord.paymentMethod}</span>
                                        <span class="badge bg-success-subtle text-success">${ord.paymentStatus}</span>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-flex align-items-center gap-1">
                                            <input type="hidden" name="orderId" value="${ord.orderId}">
                                            <select name="orderStatus" class="form-select form-select-sm" onchange="this.form.submit()" style="width: 140px;">
                                                <option value="PLACED" ${ord.orderStatus == 'PLACED' ? 'selected' : ''}>Placed</option>
                                                <option value="PROCESSING" ${ord.orderStatus == 'PROCESSING' ? 'selected' : ''}>Processing</option>
                                                <option value="SHIPPED" ${ord.orderStatus == 'SHIPPED' ? 'selected' : ''}>Shipped</option>
                                                <option value="DELIVERED" ${ord.orderStatus == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                                <option value="CANCELLED" ${ord.orderStatus == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                            </select>
                                        </form>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <a href="${pageContext.request.contextPath}/order-details?id=${ord.orderId}" 
                                           class="btn btn-outline-secondary btn-sm rounded-pill" title="View Order Details">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</div>

<%@ include file="/fragments/footer.jsp" %>
