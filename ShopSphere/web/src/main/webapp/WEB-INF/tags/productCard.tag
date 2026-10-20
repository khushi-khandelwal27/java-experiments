<%@ tag description="Product Card Component" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ attribute name="product" type="com.shopsphere.model.Product" required="true" %>

<div class="col">
    <div class="product-card shadow-sm">
        <div class="product-image-container">
            <c:choose>
                <c:when test="${not empty product.imageUrl}">
                    <img src="${product.imageUrl}" alt="${product.name}" loading="lazy">
                </c:when>
                <c:otherwise>
                    <img src="https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500" alt="Placeholder">
                </c:otherwise>
            </c:choose>

            <c:if test="${product.discount > 0}">
                <span class="product-badge-discount">
                    <fmt:formatNumber value="${product.discount}" maxFractionDigits="0"/>% OFF
                </span>
            </c:if>

            <form action="${pageContext.request.contextPath}/wishlist" method="post">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="productId" value="${product.productId}">
                <input type="hidden" name="returnUrl" value="${pageContext.request.requestURI}">
                <button type="submit" class="product-wishlist-btn" title="Add to Wishlist">
                    <i class="bi bi-heart"></i>
                </button>
            </form>
        </div>

        <div class="product-body">
            <span class="product-brand">${product.brand}</span>
            <a href="${pageContext.request.contextPath}/product-details?id=${product.productId}" class="text-decoration-none">
                <h5 class="product-title" title="${product.name}">${product.name}</h5>
            </a>

            <div class="d-flex align-items-baseline mb-3">
                <span class="price-current">₹<fmt:formatNumber value="${product.discountedPrice}" pattern="#,##0.00"/></span>
                <c:if test="${product.discount > 0}">
                    <span class="price-original">₹<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
                </c:if>
            </div>

            <div class="mt-auto d-flex gap-2">
                <c:choose>
                    <c:when test="${product.inStock}">
                        <form action="${pageContext.request.contextPath}/cart" method="post" class="flex-grow-1">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.productId}">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit" class="btn btn-shopsphere w-100 btn-sm d-flex align-items-center justify-content-center gap-1">
                                <i class="bi bi-cart-plus"></i> Add to Cart
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-secondary w-100 btn-sm disabled">Out of Stock</button>
                    </c:otherwise>
                </c:choose>
                <a href="${pageContext.request.contextPath}/product-details?id=${product.productId}" 
                   class="btn btn-outline-secondary btn-sm" title="View details">
                    <i class="bi bi-eye"></i>
                </a>
            </div>
        </div>
    </div>
</div>
