<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Profile - ShopSphere" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<main class="py-5 bg-light">
    <div class="container">
        <h2 class="fw-bold mb-4 d-flex align-items-center gap-2">
            <i class="bi bi-person-circle text-primary"></i> Account Settings
        </h2>

        <!-- Status Alerts -->
        <c:if test="${param.msg == 'updated'}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Profile details updated successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${param.msg == 'pwd_changed'}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Password changed successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${param.error == 'invalid_current_pwd'}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 small mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>Current password was incorrect.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${param.msg == 'addr_added'}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>New delivery address saved to your address book.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- Personal Info & Security -->
            <div class="col-lg-6">
                <!-- Profile Card -->
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                    <h5 class="fw-bold mb-3">Personal Information</h5>
                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <input type="hidden" name="action" value="updateProfile">
                        
                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Email Address (Read-only)</label>
                            <input type="email" class="form-control form-control-sm bg-light" value="${profileUser.email}" readonly>
                        </div>

                        <div class="mb-3">
                            <label for="name" class="form-label small fw-semibold">Full Name</label>
                            <input type="text" class="form-control form-control-sm" id="name" name="name" value="${profileUser.name}" required>
                        </div>

                        <div class="mb-3">
                            <label for="mobile" class="form-label small fw-semibold">Mobile Number</label>
                            <input type="text" class="form-control form-control-sm" id="mobile" name="mobile" value="${profileUser.mobile}">
                        </div>

                        <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4">Update Profile</button>
                    </form>
                </div>

                <!-- Password Card -->
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                    <h5 class="fw-bold mb-3">Change Password</h5>
                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <input type="hidden" name="action" value="changePassword">

                        <div class="mb-3">
                            <label for="currentPassword" class="form-label small fw-semibold">Current Password</label>
                            <input type="password" class="form-control form-control-sm" id="currentPassword" name="currentPassword" required>
                        </div>

                        <div class="mb-3">
                            <label for="newPassword" class="form-label small fw-semibold">New Password (min. 6 characters)</label>
                            <input type="password" class="form-control form-control-sm" id="newPassword" name="newPassword" minlength="6" required>
                        </div>

                        <button type="submit" class="btn btn-outline-primary btn-sm rounded-pill px-4">Change Password</button>
                    </form>
                </div>
            </div>

            <!-- Address Book -->
            <div class="col-lg-6">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                    <h5 class="fw-bold mb-3">Saved Addresses</h5>
                    <c:choose>
                        <c:when test="${not empty addresses && addresses.size() > 0}">
                            <div class="d-flex flex-column gap-3 mb-4">
                                <c:forEach var="addr" items="${addresses}">
                                    <div class="p-3 border rounded-3 bg-light">
                                        <span class="badge bg-secondary mb-2">${addr.addressType}</span>
                                        <div class="fw-bold small text-dark">${addr.addressLine}</div>
                                        <div class="small text-muted">${addr.city}, ${addr.state} - ${addr.pincode}</div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted small mb-3">No saved addresses found. Add one below:</p>
                        </c:otherwise>
                    </c:choose>

                    <!-- Add Address Form -->
                    <h6 class="fw-bold mb-3 pt-3 border-top">Add New Address</h6>
                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <input type="hidden" name="action" value="addAddress">

                        <div class="mb-2">
                            <label for="addressLine" class="form-label small fw-semibold">Street Address</label>
                            <input type="text" class="form-control form-control-sm" id="addressLine" name="addressLine" required>
                        </div>

                        <div class="row g-2 mb-2">
                            <div class="col-5">
                                <label for="city" class="form-label small fw-semibold">City</label>
                                <input type="text" class="form-control form-control-sm" id="city" name="city" required>
                            </div>
                            <div class="col-4">
                                <label for="state" class="form-label small fw-semibold">State</label>
                                <input type="text" class="form-control form-control-sm" id="state" name="state" value="Rajasthan" required>
                            </div>
                            <div class="col-3">
                                <label for="pincode" class="form-label small fw-semibold">Pincode</label>
                                <input type="text" class="form-control form-control-sm" id="pincode" name="pincode" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Type</label>
                            <select name="addressType" class="form-select form-select-sm">
                                <option value="HOME">Home</option>
                                <option value="OFFICE">Office</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-outline-success btn-sm rounded-pill px-4">Save Address</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/fragments/footer.jsp" %>
