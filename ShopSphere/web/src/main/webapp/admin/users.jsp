<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="User Accounts - ShopSphere Admin" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<div class="container-fluid">
    <div class="row">
        <%@ include file="/fragments/sidebar.jsp" %>

        <main class="col-lg-10 col-md-9 ms-sm-auto px-md-4 py-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-2 pb-3 mb-4 border-bottom">
                <h2 class="h3 fw-bold mb-0">Registered Customers & Administrators</h2>
            </div>

            <c:if test="${param.msg == 'user_status_changed'}">
                <div class="alert alert-info alert-dismissible fade show rounded-3 small mb-4" role="alert">
                    <i class="bi bi-info-circle-fill me-2"></i>User status has been updated.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                <div class="card-header bg-white py-3 px-4 fw-bold">
                    User Accounts Directory (${users.size()})
                </div>
                <div class="table-responsive">
                    <table class="table align-middle mb-0 small">
                        <thead class="bg-light">
                            <tr>
                                <th class="ps-4">User ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Mobile</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th class="pe-4 text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td class="ps-4 fw-bold text-muted">#USR-${u.userId}</td>
                                    <td><strong>${u.name}</strong></td>
                                    <td>${u.email}</td>
                                    <td>${not empty u.mobile ? u.mobile : 'N/A'}</td>
                                    <td>
                                        <span class="badge ${u.admin ? 'bg-primary' : 'bg-secondary'}">
                                            ${u.role}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge ${u.status == 'ACTIVE' ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'}">
                                            ${u.status}
                                        </span>
                                    </td>
                                    <td class="pe-4 text-end">
                                        <form action="${pageContext.request.contextPath}/admin/users" method="post" class="d-inline">
                                            <input type="hidden" name="userId" value="${u.userId}">
                                            <input type="hidden" name="status" value="${u.status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE'}">
                                            <button type="submit" class="btn btn-outline-secondary btn-sm rounded-pill">
                                                ${u.status == 'ACTIVE' ? 'Deactivate' : 'Activate'}
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
