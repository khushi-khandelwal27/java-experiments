<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Create Account - ShopSphere" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<main class="py-5 bg-light d-flex align-items-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                    <div class="bg-primary text-white text-center p-4">
                        <i class="bi bi-person-plus-fill fs-1"></i>
                        <h4 class="fw-bold mb-1 mt-2">Create Your Account</h4>
                        <p class="small text-white-50 mb-0">Join ShopSphere to access customized deals & tracking</p>
                    </div>

                    <div class="card-body p-4 p-md-5 bg-white">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show rounded-3 small" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/register" method="post">
                            <div class="mb-3">
                                <label for="name" class="form-label fw-semibold small">Full Name</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-person"></i></span>
                                    <input type="text" class="form-control border-start-0" id="name" name="name" 
                                           placeholder="e.g. Mehul Sharma" value="${enteredName}" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="email" class="form-label fw-semibold small">Email Address</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-envelope"></i></span>
                                    <input type="email" class="form-control border-start-0" id="email" name="email" 
                                           placeholder="name@example.com" value="${enteredEmail}" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="mobile" class="form-label fw-semibold small">Mobile Number</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-phone"></i></span>
                                    <input type="tel" class="form-control border-start-0" id="mobile" name="mobile" 
                                           placeholder="e.g. 9876543210" value="${enteredMobile}">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="password" class="form-label fw-semibold small">Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0"><i class="bi bi-key"></i></span>
                                        <input type="password" class="form-control border-start-0" id="password" name="password" 
                                               placeholder="Min 6 characters" minlength="6" required>
                                    </div>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="confirmPassword" class="form-label fw-semibold small">Confirm Password</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0"><i class="bi bi-shield-check"></i></span>
                                        <input type="password" class="form-control border-start-0" id="confirmPassword" name="confirmPassword" 
                                               placeholder="Re-enter password" minlength="6" required>
                                    </div>
                                </div>
                            </div>

                            <div class="form-check mb-4">
                                <input class="form-check-input" type="checkbox" id="terms" required checked>
                                <label class="form-check-label small text-muted" for="terms">
                                    I agree to the <a href="#" class="text-primary text-decoration-none">Terms of Service</a> & <a href="#" class="text-primary text-decoration-none">Privacy Policy</a>
                                </label>
                            </div>

                            <button type="submit" class="btn btn-shopsphere w-100 py-2 fw-bold shadow-sm">
                                Complete Registration
                            </button>
                        </form>

                        <div class="text-center mt-4 pt-2 border-top">
                            <span class="small text-muted">Already have an account?</span>
                            <a href="${pageContext.request.contextPath}/login" class="small fw-bold text-primary text-decoration-none ms-1">
                                Sign In
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/fragments/footer.jsp" %>
