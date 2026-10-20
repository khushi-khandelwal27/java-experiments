<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<c:set var="pageTitle" value="Product Catalog - ShopSphere" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<main class="py-4">
    <div class="container">
        <!-- Breadcrumb & Header -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb small mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none">Home</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Catalog</li>
                    </ol>
                </nav>
                <h2 class="fw-bold mb-0">
                    <c:choose>
                        <c:when test="${not empty searchQuery}">Search results for "${searchQuery}"</c:when>
                        <c:otherwise>All Products</c:otherwise>
                    </c:choose>
                </h2>
                <small class="text-muted">Showing ${products != null ? products.size() : 0} items available</small>
            </div>

            <!-- Sort By -->
            <form action="${pageContext.request.contextPath}/products" method="get" class="d-flex align-items-center gap-2 mt-3 mt-md-0">
                <c:if test="${not empty selectedCategory}">
                    <input type="hidden" name="category" value="${selectedCategory}">
                </c:if>
                <c:if test="${not empty searchQuery}">
                    <input type="hidden" name="q" value="${searchQuery}">
                </c:if>
                <label for="sortSelect" class="small fw-semibold text-muted text-nowrap">Sort By:</label>
                <select name="sort" id="sortSelect" class="form-select form-select-sm rounded-pill" onchange="this.form.submit()">
                    <option value="" ${empty currentSort ? 'selected' : ''}>Featured / Newest</option>
                    <option value="price_asc" ${currentSort == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
                    <option value="price_desc" ${currentSort == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
                    <option value="discount" ${currentSort == 'discount' ? 'selected' : ''}>Highest Discount</option>
                </select>
            </form>
        </div>

        <div class="row g-4">
            <!-- Sidebar Filters -->
            <div class="col-lg-3">
                <div class="card border-0 shadow-sm rounded-4 p-3 mb-4">
                    <h6 class="fw-bold mb-3 d-flex align-items-center justify-content-between">
                        <span>Categories</span>
                        <a href="${pageContext.request.contextPath}/products" class="small text-primary text-decoration-none">Reset</a>
                    </h6>
                    <div class="list-group list-group-flush small">
                        <a href="${pageContext.request.contextPath}/products" 
                           class="list-group-item list-group-item-action d-flex justify-content-between align-items-center border-0 px-2 py-2 rounded-2 ${empty selectedCategory ? 'active bg-primary' : ''}">
                            <span>All Categories</span>
                        </a>
                        <c:forEach var="cat" items="${categories}">
                            <a href="${pageContext.request.contextPath}/products?category=${cat.categoryId}&sort=${currentSort}&q=${searchQuery}" 
                               class="list-group-item list-group-item-action d-flex justify-content-between align-items-center border-0 px-2 py-2 rounded-2 ${selectedCategory == cat.categoryId ? 'active bg-primary' : ''}">
                                <span>${cat.name}</span>
                            </a>
                        </c:forEach>
                    </div>
                </div>

                <!-- Viva Hint Card -->
                <div class="card border-0 bg-light p-3 rounded-4 small text-muted">
                    <div class="fw-bold text-dark mb-1"><i class="bi bi-code-slash text-primary me-1"></i> RTU Lab Concept</div>
                    This catalog is powered by Jakarta Servlets and custom JSP tag files (`productCard.tag`), consuming PreparedStatement SQL queries from `ProductDAO`.
                </div>
            </div>

            <!-- Product Grid -->
            <div class="col-lg-9">
                <c:choose>
                    <c:when test="${not empty products && products.size() > 0}">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4">
                            <c:forEach var="product" items="${products}">
                                <tags:productCard product="${product}"/>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5 bg-white rounded-4 shadow-sm border border-light">
                            <i class="bi bi-search text-muted display-4"></i>
                            <h4 class="fw-bold mt-3">No Products Found</h4>
                            <p class="text-muted">We couldn't find any products matching your current criteria.</p>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-4">
                                Browse All Products
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

<%@ include file="/fragments/footer.jsp" %>
