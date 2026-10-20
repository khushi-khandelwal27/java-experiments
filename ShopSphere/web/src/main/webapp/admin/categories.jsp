<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Category Management - ShopSphere Admin" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<div class="container-fluid">
    <div class="row">
        <%@ include file="/fragments/sidebar.jsp" %>

        <main class="col-lg-10 col-md-9 ms-sm-auto px-md-4 py-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-2 pb-3 mb-4 border-bottom">
                <h2 class="h3 fw-bold mb-0">Category Management</h2>
            </div>

            <c:if test="${param.msg == 'created'}">
                <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>Category created successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'updated'}">
                <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>Category updated successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'deleted'}">
                <div class="alert alert-warning alert-dismissible fade show rounded-3 small mb-4" role="alert">
                    <i class="bi bi-trash-fill me-2"></i>Category deleted.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="row g-4">
                <!-- Add/Edit Category Form -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                        <h5 class="fw-bold mb-3">
                            <c:choose>
                                <c:when test="${not empty editCategory}">Edit Category</c:when>
                                <c:otherwise>Create New Category</c:otherwise>
                            </c:choose>
                        </h5>

                        <form action="${pageContext.request.contextPath}/admin/categories" method="post">
                            <c:if test="${not empty editCategory}">
                                <input type="hidden" name="categoryId" value="${editCategory.categoryId}">
                            </c:if>

                            <div class="mb-3">
                                <label class="form-label small fw-semibold">Category Name</label>
                                <input type="text" class="form-control form-control-sm" name="name" 
                                       value="${editCategory != null ? editCategory.name : ''}" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-semibold">Description</label>
                                <textarea class="form-control form-control-sm" name="description" rows="3" required>${editCategory != null ? editCategory.description : ''}</textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-semibold">Status</label>
                                <select name="status" class="form-select form-select-sm">
                                    <option value="ACTIVE" ${editCategory == null || editCategory.status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                                    <option value="INACTIVE" ${editCategory != null && editCategory.status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                                </select>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4">
                                    Save Category
                                </button>
                                <c:if test="${not empty editCategory}">
                                    <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
                                        Cancel
                                    </a>
                                </c:if>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Existing Categories Table -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                        <div class="card-header bg-white py-3 px-4 fw-bold">
                            All Categories (${categories.size()})
                        </div>
                        <div class="table-responsive">
                            <table class="table align-middle mb-0 small">
                                <thead class="bg-light">
                                    <tr>
                                        <th class="ps-4">ID</th>
                                        <th>Name</th>
                                        <th>Description</th>
                                        <th>Status</th>
                                        <th class="pe-4 text-end">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${categories}">
                                        <tr>
                                            <td class="ps-4 fw-bold text-muted">#${c.categoryId}</td>
                                            <td class="fw-bold">${c.name}</td>
                                            <td class="text-muted text-truncate" style="max-width: 250px;">${c.description}</td>
                                            <td>
                                                <span class="badge ${c.status == 'ACTIVE' ? 'bg-success-subtle text-success' : 'bg-secondary-subtle text-secondary'}">
                                                    ${c.status}
                                                </span>
                                            </td>
                                            <td class="pe-4 text-end">
                                                <a href="${pageContext.request.contextPath}/admin/categories?action=edit&id=${c.categoryId}" 
                                                   class="btn btn-outline-primary btn-sm rounded-pill me-1" title="Edit">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <form action="${pageContext.request.contextPath}/admin/categories" method="post" class="d-inline" onsubmit="return confirm('Delete this category?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${c.categoryId}">
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
                </div>
            </div>
        </main>
    </div>
</div>

<%@ include file="/fragments/footer.jsp" %>
