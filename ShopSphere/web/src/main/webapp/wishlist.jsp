<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="My Wishlist - ShopSphere" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <h2 class="fw-bold mb-4 d-flex align-items-center gap-2">
            <i class="bi bi-heart-fill text-danger"></i> My Wishlist (${wishlistItems != null ? wishlistItems.size() : 0})
        </h2>

        <c:choose>
            <c:when test="${not empty wishlistItems && wishlistItems.size() > 0}">
                <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
                    <c:forEach var="item" items="${wishlistItems}">
                        <div class="col">
                            <div class="product-card shadow-sm h-100">
                                <div class="product-image-container">
                                    <img src="${item.product.imageUrl}" alt="${item.product.name}">
                                </div>
                                <div class="product-body">
                                    <span class="product-brand">${item.product.brand}</span>
                                    <a href="${pageContext.request.contextPath}/product-details?id=${item.productId}" class="text-decoration-none">
                                        <h6 class="product-title">${item.product.name}</h6>
                                    </a>
                                    <div class="mb-3">
                                        <span class="price-current">₹<fmt:formatNumber value="${item.product.discountedPrice}" pattern="#,##0.00"/></span>
                                    </div>
                                    <div class="mt-auto d-flex gap-2">
                                        <form action="${pageContext.request.contextPath}/cart" method="post" class="flex-grow-1">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productId" value="${item.productId}">
                                            <button type="submit" class="btn btn-shopsphere btn-sm w-100">
                                                <i class="bi bi-cart-plus me-1"></i>Move to Cart
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/wishlist" method="post">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="productId" value="${item.productId}">
                                            <button type="submit" class="btn btn-outline-danger btn-sm" title="Remove from Wishlist">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white my-4">
                    <div class="display-3 text-muted mb-3"><i class="bi bi-heart"></i></div>
                    <h3 class="fw-bold">Your Wishlist is Empty</h3>
                    <p class="text-muted mb-4">Click the heart icon on any product to save items you love for later.</p>
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
