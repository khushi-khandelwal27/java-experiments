<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Sign In - ShopSphere" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<main class="py-5 bg-light d-flex align-items-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-5">
                <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                    <div class="bg-primary text-white text-center p-4">
                        <i class="bi bi-shield-lock-fill fs-1"></i>
                        <h4 class="fw-bold mb-1 mt-2">Welcome Back</h4>
                        <p class="small text-white-50 mb-0">Sign in to your ShopSphere account</p>
                    </div>

                    <div class="card-body p-4 p-md-5 bg-white">
                        <!-- Alerts -->
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show rounded-3 small" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show rounded-3 small" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i>${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${param.msg == 'logged_out'}">
                            <div class="alert alert-info rounded-3 small">
                                <i class="bi bi-info-circle-fill me-2"></i>You have been logged out successfully.
                            </div>
                        </c:if>

                        <c:if test="${param.msg == 'auth_required'}">
                            <div class="alert alert-warning rounded-3 small">
                                <i class="bi bi-lock-fill me-2"></i>Please sign in to proceed to your cart or orders.
                            </div>
                        </c:if>

                        <c:if test="${param.error == 'admin_access_required'}">
                            <div class="alert alert-danger rounded-3 small">
                                <i class="bi bi-shield-slash-fill me-2"></i>Access restricted. Administrator privileges required.
                            </div>
                        </c:if>

                        <!-- Login Form -->
                        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
                            <div class="mb-3">
                                <label for="email" class="form-label fw-semibold small">Email Address</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-envelope"></i></span>
                                    <input type="email" class="form-control border-start-0" id="email" name="email" 
                                           placeholder="name@example.com" value="${enteredEmail != null ? enteredEmail : cookie.savedUserEmail.value}" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label fw-semibold small">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-key"></i></span>
                                    <input type="password" class="form-control border-start-0" id="password" name="password" 
                                           placeholder="••••••••" required>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe" 
                                           ${not empty cookie.savedUserEmail ? 'checked' : ''}>
                                    <label class="form-check-label small text-muted" for="rememberMe">
                                        Remember email (Cookie demo)
                                    </label>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-shopsphere w-100 py-2 fw-bold shadow-sm">
                                <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
                            </button>
                        </form>

                        <!-- Quick Credentials For Lab Viva Demonstration -->
                        <div class="mt-4 pt-3 border-top text-center">
                            <small class="text-muted fw-bold d-block mb-2">⚡ Lab Examiner / Quick Fill:</small>
                            <div class="d-flex justify-content-center gap-2 flex-wrap">
                                <button type="button" class="btn btn-outline-primary btn-sm rounded-pill" onclick="quickFill('admin@shopsphere.com', 'admin123')">
                                    <i class="bi bi-shield-fill-check me-1"></i>Fill Admin
                                </button>
                                <button type="button" class="btn btn-outline-secondary btn-sm rounded-pill" onclick="quickFill('rahul@example.com', 'user123')">
                                    <i class="bi bi-person-fill me-1"></i>Fill Customer
                                </button>
                            </div>
                        </div>

                        <div class="text-center mt-4">
                            <span class="small text-muted">Don't have an account?</span>
                            <a href="${pageContext.request.contextPath}/register" class="small fw-bold text-primary text-decoration-none ms-1">
                                Create an Account
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
function quickFill(email, pwd) {
    document.getElementById('email').value = email;
    document.getElementById('password').value = pwd;
}
</script>

<%@ include file="/fragments/footer.jsp" %>
