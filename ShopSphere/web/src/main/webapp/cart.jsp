<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Your Shopping Cart - ShopSphere" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <h2 class="fw-bold mb-4 d-flex align-items-center gap-2">
            <i class="bi bi-cart3 text-primary"></i> Shopping Cart
        </h2>

        <c:choose>
            <c:when test="${not empty cartItems && cartItems.size() > 0}">
                <div class="row g-4">
                    <!-- Items List Table -->
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                            <div class="table-responsive">
                                <table class="table align-middle mb-0">
                                    <thead class="bg-light text-secondary small text-uppercase">
                                        <tr>
                                            <th class="ps-4 py-3">Product</th>
                                            <th class="py-3">Price</th>
                                            <th class="py-3 text-center">Quantity</th>
                                            <th class="py-3">Subtotal</th>
                                            <th class="pe-4 py-3 text-end">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${cartItems}">
                                            <tr>
                                                <td class="ps-4 py-3">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <img src="${item.product.imageUrl}" alt="${item.product.name}" 
                                                             class="rounded-3 shadow-sm" style="width: 64px; height: 64px; object-fit: cover;">
                                                        <div>
                                                            <a href="${pageContext.request.contextPath}/product-details?id=${item.productId}" 
                                                               class="fw-bold text-dark text-decoration-none small d-block" style="max-width: 260px;">
                                                                ${item.product.name}
                                                            </a>
                                                            <small class="text-muted text-uppercase">${item.product.brand}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="fw-bold text-dark">₹<fmt:formatNumber value="${item.product.discountedPrice}" pattern="#,##0.00"/></span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="d-flex justify-content-center align-items-center gap-1">
                                                        <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline">
                                                            <input type="hidden" name="action" value="update">
                                                            <input type="hidden" name="cartId" value="${item.cartId}">
                                                            <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                                            <button type="submit" class="btn btn-outline-secondary btn-sm rounded-circle p-0" style="width:28px;height:28px;" ${item.quantity <= 1 ? 'disabled' : ''}>-</button>
                                                        </form>
                                                        
                                                        <span class="px-2 fw-bold">${item.quantity}</span>

                                                        <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline">
                                                            <input type="hidden" name="action" value="update">
                                                            <input type="hidden" name="cartId" value="${item.cartId}">
                                                            <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                                            <button type="submit" class="btn btn-outline-secondary btn-sm rounded-circle p-0" style="width:28px;height:28px;" ${item.quantity >= item.product.stock ? 'disabled' : ''}>+</button>
                                                        </form>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="fw-bold text-primary">₹<fmt:formatNumber value="${item.itemTotal}" pattern="#,##0.00"/></span>
                                                </td>
                                                <td class="pe-4 text-end">
                                                    <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline">
                                                        <input type="hidden" name="action" value="remove">
                                                        <input type="hidden" name="cartId" value="${item.cartId}">
                                                        <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill" title="Remove item">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div class="p-3 bg-light d-flex justify-content-between align-items-center">
                                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary btn-sm rounded-pill">
                                    <i class="bi bi-arrow-left me-1"></i>Continue Shopping
                                </a>
                                <form action="${pageContext.request.contextPath}/cart" method="post">
                                    <input type="hidden" name="action" value="clear">
                                    <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill">
                                        <i class="bi bi-trash3 me-1"></i>Clear Entire Cart
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Order Summary Card -->
                    <div class="col-lg-4">
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                            <h5 class="fw-bold mb-3">Order Summary</h5>
                            
                            <div class="d-flex justify-content-between mb-2 small">
                                <span class="text-muted">Items Subtotal:</span>
                                <span class="fw-bold">₹<fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></span>
                            </div>

                            <div class="d-flex justify-content-between mb-2 small">
                                <span class="text-muted">Estimated Shipping:</span>
                                <span class="text-success fw-bold">FREE</span>
                            </div>

                            <div class="d-flex justify-content-between mb-3 small">
                                <span class="text-muted">Taxes & Fees:</span>
                                <span class="text-muted">Included</span>
                            </div>

                            <hr class="my-3">

                            <div class="d-flex justify-content-between mb-4">
                                <span class="fs-5 fw-bold">Total Amount:</span>
                                <span class="fs-5 fw-extrabold text-primary">₹<fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></span>
                            </div>

                            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-shopsphere btn-lg w-100 py-2 shadow-sm text-center">
                                Proceed to Checkout <i class="bi bi-arrow-right ms-1"></i>
                            </a>

                            <div class="mt-4 p-3 bg-light rounded-3 small text-secondary">
                                <i class="bi bi-shield-lock-fill text-success me-1"></i>
                                Bank-level 256-bit encryption. Safe checkout guaranteed.
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white my-4">
                    <div class="display-3 text-muted mb-3"><i class="bi bi-cart-x"></i></div>
                    <h3 class="fw-bold">Your Cart is Currently Empty</h3>
                    <p class="text-muted mb-4">Explore our catalog and add gadgets, fashion, and books to your basket.</p>
                    <div>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-4 py-2">
                            <i class="bi bi-bag me-2"></i>Start Shopping
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<%@ include file="/fragments/footer.jsp" %>
