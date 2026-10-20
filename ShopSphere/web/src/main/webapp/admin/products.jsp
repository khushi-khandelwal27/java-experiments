<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Product Catalog Management - ShopSphere Admin" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<div class="container-fluid">
    <div class="row">
        <%@ include file="/fragments/sidebar.jsp" %>

        <main class="col-lg-10 col-md-9 ms-sm-auto px-md-4 py-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-2 pb-3 mb-4 border-bottom">
                <h2 class="h3 fw-bold mb-0">Product Catalog Management</h2>
                <a href="#productFormCard" class="btn btn-primary rounded-pill btn-sm">
                    <i class="bi bi-plus-lg me-1"></i>Add New Product
                </a>
            </div>

            <!-- Alerts -->
            <c:if test="${param.msg == 'created'}">
                <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>Product created successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'updated'}">
                <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>Product updated successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'deleted'}">
                <div class="alert alert-warning alert-dismissible fade show rounded-3 small mb-4" role="alert">
                    <i class="bi bi-trash-fill me-2"></i>Product deleted from catalog.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Product Form Card (Add/Edit) -->
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-5" id="productFormCard">
                <h5 class="fw-bold mb-3">
                    <c:choose>
                        <c:when test="${not empty editProduct}">Edit Product: ${editProduct.name}</c:when>
                        <c:otherwise>Add New Catalog Item</c:otherwise>
                    </c:choose>
                </h5>

                <form action="${pageContext.request.contextPath}/admin/products" method="post">
                    <c:if test="${not empty editProduct}">
                        <input type="hidden" name="productId" value="${editProduct.productId}">
                    </c:if>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Product Name</label>
                            <input type="text" class="form-control form-control-sm" name="name" 
                                   value="${editProduct != null ? editProduct.name : ''}" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Brand / Manufacturer</label>
                            <input type="text" class="form-control form-control-sm" name="brand" 
                                   value="${editProduct != null ? editProduct.brand : ''}" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Category</label>
                            <select name="categoryId" class="form-select form-select-sm" required>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat.categoryId}" ${editProduct != null && editProduct.categoryId == cat.categoryId ? 'selected' : ''}>
                                        ${cat.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label small fw-semibold">Description</label>
                            <textarea class="form-control form-control-sm" name="description" rows="2" required>${editProduct != null ? editProduct.description : ''}</textarea>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Price (₹)</label>
                            <input type="number" step="0.01" class="form-control form-control-sm" name="price" 
                                   value="${editProduct != null ? editProduct.price : '999.00'}" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Discount (%)</label>
                            <input type="number" step="0.01" class="form-control form-control-sm" name="discount" 
                                   value="${editProduct != null ? editProduct.discount : '0.00'}">
                        </div>

                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Initial Stock Units</label>
                            <input type="number" class="form-control form-control-sm" name="stock" 
                                   value="${editProduct != null ? editProduct.stock : '25'}" required>
                        </div>

                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Status</label>
                            <select name="status" class="form-select form-select-sm">
                                <option value="ACTIVE" ${editProduct == null || editProduct.status == 'ACTIVE' ? 'selected' : ''}>Active (Visible)</option>
                                <option value="INACTIVE" ${editProduct != null && editProduct.status == 'INACTIVE' ? 'selected' : ''}>Inactive (Hidden)</option>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label small fw-semibold">Image URL (HTTPS link to picture)</label>
                            <input type="url" class="form-control form-control-sm" name="imageUrl" 
                                   value="${editProduct != null ? editProduct.imageUrl : 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500'}">
                        </div>
                    </div>

                    <div class="mt-4 d-flex gap-2">
                        <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4">
                            <i class="bi bi-save me-1"></i>Save Product
                        </button>
                        <c:if test="${not empty editProduct}">
                            <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
                                Cancel
                            </a>
                        </c:if>
                    </div>
                </form>
            </div>

            <!-- Existing Products Table -->
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                <div class="card-header bg-white py-3 px-4 fw-bold">
                    All Catalog Products (${products.size()})
                </div>
                <div class="table-responsive">
                    <table class="table align-middle mb-0 small">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4">ID</th>
                                <th>Product</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Discount</th>
                                <th>Stock</th>
                                <th>Status</th>
                                <th class="pe-4 text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${products}">
                                <tr>
                                    <td class="ps-4 fw-bold text-muted">#${p.productId}</td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <img src="${p.imageUrl}" alt="" class="rounded-2" style="width: 36px; height: 36px; object-fit: cover;">
                                            <div>
                                                <strong>${p.name}</strong><br>
                                                <small class="text-muted">${p.brand}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${p.categoryName}</td>
                                    <td class="fw-bold">₹<fmt:formatNumber value="${p.price}" pattern="#,##0.00"/></td>
                                    <td>${p.discount}%</td>
                                    <td>
                                        <span class="badge ${p.stock <= 10 ? 'bg-danger-subtle text-danger' : 'bg-success-subtle text-success'}">
                                            ${p.stock} in stock
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge ${p.status == 'ACTIVE' ? 'bg-success-subtle text-success' : 'bg-secondary-subtle text-secondary'}">
                                            ${p.status}
                                        </span>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.productId}" 
                                           class="btn btn-outline-primary btn-sm rounded-pill me-1" title="Edit">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <form action="${pageContext.request.contextPath}/admin/products" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this product?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${p.productId}">
                                            <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill" title="Delete">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
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
