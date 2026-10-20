<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="${product.name} - ShopSphere" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<main class="py-4">
    <div class="container">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb small">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products" class="text-decoration-none">Products</a></li>
                <li class="breadcrumb-item active" aria-current="page">${product.name}</li>
            </ol>
        </nav>

        <c:if test="${param.msg == 'review_added'}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Thank you! Your product review has been submitted.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-5">
            <!-- Product Image -->
            <div class="col-lg-6">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden p-2 bg-white">
                    <img src="${product.imageUrl != null ? product.imageUrl : 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600'}" 
                         alt="${product.name}" class="img-fluid rounded-3 w-100" style="max-height: 480px; object-fit: cover;">
                </div>
            </div>

            <!-- Product Info & Actions -->
            <div class="col-lg-6">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="badge bg-secondary-subtle text-secondary text-uppercase fw-bold px-3 py-1 rounded-pill">
                        ${product.brand}
                    </span>
                    <c:choose>
                        <c:when test="${product.inStock}">
                            <span class="badge bg-success-subtle text-success fw-bold px-3 py-1 rounded-pill">
                                <i class="bi bi-check-circle-fill me-1"></i>In Stock (${product.stock} available)
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-danger-subtle text-danger fw-bold px-3 py-1 rounded-pill">
                                Out of Stock
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <h2 class="fw-extrabold mb-3 text-dark">${product.name}</h2>

                <!-- Rating -->
                <div class="mb-3">
                    <tags:rating value="${avgRating}" count="${reviewCount}"/>
                </div>

                <!-- Price -->
                <div class="d-flex align-items-baseline gap-3 mb-4 p-3 bg-light rounded-3">
                    <span class="display-6 fw-bold text-dark">₹<fmt:formatNumber value="${product.discountedPrice}" pattern="#,##0.00"/></span>
                    <c:if test="${product.discount > 0}">
                        <span class="text-decoration-line-through text-muted fs-5">₹<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
                        <span class="badge bg-danger text-white rounded-pill px-2 py-1">${product.discount}% OFF</span>
                    </c:if>
                </div>

                <p class="text-secondary leading-relaxed mb-4">
                    ${product.description}
                </p>

                <!-- Add to Cart Form -->
                <c:if test="${product.inStock}">
                    <form action="${pageContext.request.contextPath}/cart" method="post" class="mb-4">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="${product.productId}">
                        
                        <div class="row g-3 align-items-center mb-3">
                            <div class="col-auto">
                                <label for="quantity" class="col-form-label fw-bold small">Quantity:</label>
                            </div>
                            <div class="col-auto">
                                <input type="number" id="quantity" name="quantity" class="form-control text-center" 
                                       value="1" min="1" max="${product.stock}" style="width: 80px;">
                            </div>
                        </div>

                        <div class="d-flex gap-3">
                            <button type="submit" class="btn btn-shopsphere btn-lg flex-grow-1 shadow-sm">
                                <i class="bi bi-cart-plus me-2"></i>Add to Cart
                            </button>
                            <a href="${pageContext.request.contextPath}/wishlist" 
                               onclick="event.preventDefault(); document.getElementById('wishlistForm').submit();" 
                               class="btn btn-outline-secondary btn-lg d-flex align-items-center justify-content-center" 
                               title="Wishlist">
                                <i class="bi ${inWishlist ? 'bi-heart-fill text-danger' : 'bi-heart'}"></i>
                            </a>
                        </div>
                    </form>

                    <form id="wishlistForm" action="${pageContext.request.contextPath}/wishlist" method="post" style="display:none;">
                        <input type="hidden" name="action" value="${inWishlist ? 'remove' : 'add'}">
                        <input type="hidden" name="productId" value="${product.productId}">
                        <input type="hidden" name="returnUrl" value="${pageContext.request.requestURI}?id=${product.productId}">
                    </form>
                </c:if>

                <!-- Features Checklist -->
                <div class="row g-3 pt-3 border-top text-secondary small">
                    <div class="col-6"><i class="bi bi-truck text-primary me-2"></i>Free Standard Delivery</div>
                    <div class="col-6"><i class="bi bi-shield-check text-primary me-2"></i>1 Year Brand Warranty</div>
                    <div class="col-6"><i class="bi bi-arrow-clockwise text-primary me-2"></i>7 Days Return Policy</div>
                    <div class="col-6"><i class="bi bi-cookie text-primary me-2"></i>Cookie State Active</div>
                </div>
            </div>
        </div>

        <!-- Customer Reviews & Rating Form -->
        <div class="mt-5 pt-4 border-top">
            <div class="row g-5">
                <div class="col-lg-7">
                    <h4 class="fw-bold mb-4">Customer Reviews (${reviewCount})</h4>
                    <c:choose>
                        <c:when test="${not empty reviews && reviews.size() > 0}">
                            <div class="d-flex flex-column gap-3">
                                <c:forEach var="rev" items="${reviews}">
                                    <div class="p-3 bg-white rounded-3 shadow-sm border border-light">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div class="d-flex align-items-center gap-2">
                                                <i class="bi bi-person-circle fs-5 text-secondary"></i>
                                                <strong class="text-dark">${rev.userName}</strong>
                                            </div>
                                            <div class="text-warning small">
                                                <c:forEach begin="1" end="${rev.rating}"><i class="bi bi-star-fill"></i></c:forEach>
                                                <c:forEach begin="${rev.rating + 1}" end="5"><i class="bi bi-star text-muted opacity-50"></i></c:forEach>
                                            </div>
                                        </div>
                                        <p class="text-secondary small mb-1">${rev.reviewText}</p>
                                        <small class="text-muted" style="font-size: 0.75rem;"><fmt:formatDate value="${rev.createdAt}" pattern="dd MMM yyyy, hh:mm a"/></small>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted">No reviews yet for this product. Be the first to review!</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Write a review form -->
                <div class="col-lg-5">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                        <h5 class="fw-bold mb-3">Write a Customer Review</h5>
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <form action="${pageContext.request.contextPath}/review" method="post">
                                    <input type="hidden" name="productId" value="${product.productId}">
                                    <div class="mb-3">
                                        <label for="ratingSelect" class="form-label small fw-semibold">Your Rating</label>
                                        <select name="rating" id="ratingSelect" class="form-select form-select-sm" required>
                                            <option value="5">⭐⭐⭐⭐⭐ (5 - Outstanding)</option>
                                            <option value="4">⭐⭐⭐⭐ (4 - Very Good)</option>
                                            <option value="3">⭐⭐⭐ (3 - Average)</option>
                                            <option value="2">⭐⭐ (2 - Below Expectations)</option>
                                            <option value="1">⭐ (1 - Poor)</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label for="reviewText" class="form-label small fw-semibold">Feedback & Experience</label>
                                        <textarea name="reviewText" id="reviewText" class="form-control" rows="3" 
                                                  placeholder="What did you like or dislike about this product?" required></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4">Submit Review</button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted small">Please <a href="${pageContext.request.contextPath}/login" class="text-primary fw-semibold">sign in</a> to submit a verified product review.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/fragments/footer.jsp" %>
