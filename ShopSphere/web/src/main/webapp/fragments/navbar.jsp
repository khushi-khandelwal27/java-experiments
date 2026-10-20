<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg navbar-shopsphere sticky-top shadow-sm py-2">
    <div class="container">
        <!-- Brand Logo -->
        <a class="navbar-brand d-flex align-items-center gap-2 fs-4" href="${pageContext.request.contextPath}/index.jsp">
            <i class="bi bi-bag-heart-fill fs-3" style="color: #4f46e5;"></i>
            <span>ShopSphere</span>
        </a>

        <!-- Mobile Toggler -->
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <!-- Navigation Links & Categories -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 align-items-lg-center">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/products">All Products</a>
                </li>

                <!-- Categories Dropdown -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        Categories
                    </a>
                    <ul class="dropdown-menu border-0 shadow-sm rounded-3">
                        <c:forEach var="cat" items="${applicationScope.globalCategories}">
                            <li>
                                <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/products?category=${cat.categoryId}">
                                    ${cat.name}
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </li>

                <!-- Syllabus Demonstrations Dropdown (RTU Lab Viva) -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-primary" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="bi bi-mortarboard-fill me-1"></i>Syllabus Demos
                    </a>
                    <ul class="dropdown-menu border-0 shadow-sm rounded-3">
                        <li><h6 class="dropdown-header text-uppercase">RTU Lab Syllabus Modules</h6></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/syllabus/jsp-elements.jsp">1. JSP Lifecycle & Elements</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/syllabus/jstl-demo.jsp">2. JSTL (Core, SQL, XML, Fn)</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/syllabus/i18n-demo.jsp">3. Internationalization (i18n)</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/syllabus/jndi-url-demo.jsp">4. JNDI & java.net URL Protocol</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/syllabus/networking-rmi.jsp">5. Sockets & RMI Architecture</a></li>
                    </ul>
                </li>
            </ul>

            <!-- Search Form -->
            <form class="d-flex me-lg-3 my-2 my-lg-0" action="${pageContext.request.contextPath}/products" method="get">
                <div class="input-group">
                    <input class="form-control rounded-start-pill bg-light border-end-0 ps-3" type="search" 
                           placeholder="Search gadgets, clothing, books..." name="q" value="${param.q}" style="min-width: 220px;">
                    <button class="btn btn-light rounded-end-pill border border-start-0 text-secondary pe-3" type="submit">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </form>

            <!-- User Actions (Cart, Wishlist, Profile/Login) -->
            <div class="d-flex align-items-center gap-3">
                <!-- Wishlist -->
                <a href="${pageContext.request.contextPath}/wishlist" class="text-secondary fs-5 text-decoration-none position-relative" title="Wishlist">
                    <i class="bi bi-heart"></i>
                </a>

                <!-- Cart -->
                <a href="${pageContext.request.contextPath}/cart" class="text-secondary fs-5 text-decoration-none position-relative" title="Cart">
                    <i class="bi bi-bag"></i>
                    <c:if test="${sessionScope.cartCount > 0}">
                        <span class="badge bg-danger cart-badge">${sessionScope.cartCount}</span>
                    </c:if>
                </a>

                <!-- Authentication / User Menu -->
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="dropdown">
                            <button class="btn btn-outline-secondary dropdown-toggle rounded-pill d-flex align-items-center gap-2 py-1 px-3" type="button" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle fs-6"></i>
                                <span class="fw-semibold small">${sessionScope.user.name}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end border-0 shadow-sm rounded-3">
                                <li><span class="dropdown-item-text text-muted small">${sessionScope.user.email}</span></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person me-2"></i>My Profile</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders"><i class="bi bi-box-seam me-2"></i>My Orders</a></li>
                                <c:if test="${sessionScope.user.admin}">
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-primary fw-bold" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i>Admin Dashboard</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary rounded-pill px-3 py-1 btn-sm fw-semibold">Sign In</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary rounded-pill px-3 py-1 btn-sm fw-semibold">Register</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
