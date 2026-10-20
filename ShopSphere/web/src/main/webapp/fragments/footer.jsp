<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="bg-dark text-white pt-5 pb-4 mt-auto">
    <div class="container">
        <div class="row g-4">
            <!-- Brand & Info -->
            <div class="col-lg-4 col-md-6">
                <div class="d-flex align-items-center gap-2 mb-3">
                    <i class="bi bi-bag-heart-fill fs-3 text-primary"></i>
                    <span class="fs-4 fw-bold">ShopSphere</span>
                </div>
                <p class="text-secondary small">
                    An advanced, enterprise-grade Java E-Commerce platform built for the Rajasthan Technical University (RTU) Advanced Java syllabus. Features N-tier architecture, Jakarta Servlets, JSP, JDBC, RMI, Sockets, and Swing.
                </p>
                <div class="d-flex gap-3 text-secondary fs-5 mt-3">
                    <a href="#" class="text-secondary hover-text-white"><i class="bi bi-github"></i></a>
                    <a href="#" class="text-secondary hover-text-white"><i class="bi bi-linkedin"></i></a>
                    <a href="#" class="text-secondary hover-text-white"><i class="bi bi-globe"></i></a>
                </div>
            </div>

            <!-- Quick Links -->
            <div class="col-lg-2 col-md-6">
                <h6 class="text-uppercase fw-bold mb-3 text-light">Explore</h6>
                <ul class="list-unstyled small d-flex flex-column gap-2 text-secondary">
                    <li><a href="${pageContext.request.contextPath}/index.jsp" class="text-secondary text-decoration-none">Home Storefront</a></li>
                    <li><a href="${pageContext.request.contextPath}/products" class="text-secondary text-decoration-none">Catalog & Search</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart" class="text-secondary text-decoration-none">Shopping Cart</a></li>
                    <li><a href="${pageContext.request.contextPath}/orders" class="text-secondary text-decoration-none">Track Orders</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-secondary text-decoration-none">Admin Portal</a></li>
                </ul>
            </div>

            <!-- Syllabus Topics -->
            <div class="col-lg-3 col-md-6">
                <h6 class="text-uppercase fw-bold mb-3 text-light">RTU Syllabus Modules</h6>
                <ul class="list-unstyled small d-flex flex-column gap-2 text-secondary">
                    <li><a href="${pageContext.request.contextPath}/syllabus/jsp-elements.jsp" class="text-secondary text-decoration-none">JSP Architecture & Elements</a></li>
                    <li><a href="${pageContext.request.contextPath}/syllabus/jstl-demo.jsp" class="text-secondary text-decoration-none">JSTL Core, SQL & XML</a></li>
                    <li><a href="${pageContext.request.contextPath}/syllabus/i18n-demo.jsp" class="text-secondary text-decoration-none">Internationalization (i18n)</a></li>
                    <li><a href="${pageContext.request.contextPath}/syllabus/jndi-url-demo.jsp" class="text-secondary text-decoration-none">JNDI Lookup & URL Handlers</a></li>
                    <li><a href="${pageContext.request.contextPath}/syllabus/networking-rmi.jsp" class="text-secondary text-decoration-none">Sockets & Java RMI Registry</a></li>
                </ul>
            </div>

            <!-- System Architecture & Viva Note -->
            <div class="col-lg-3 col-md-6">
                <h6 class="text-uppercase fw-bold mb-3 text-light">Viva Architecture</h6>
                <div class="p-3 rounded-3" style="background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);">
                    <div class="small text-light fw-bold mb-1"><i class="bi bi-diagram-3-fill text-primary me-1"></i> Layered N-Tier</div>
                    <p class="text-secondary mb-0" style="font-size: 0.8rem;">
                        Browser &rarr; Jakarta Servlet 6.1 &rarr; Service &rarr; DAO &rarr; MySQL 8.0 &rarr; Tomcat 11.
                    </p>
                </div>
            </div>
        </div>

        <hr class="my-4 border-secondary opacity-25">

        <div class="d-flex flex-wrap justify-content-between align-items-center small text-secondary">
            <div>&copy; 2026 ShopSphere Project. All rights reserved. Designed for RTU Advanced Java Practical Lab.</div>
            <div>Built with Jakarta EE, Bootstrap 5, and Java 24</div>
        </div>
    </div>
</footer>

<!-- Bootstrap 5.3 JS Bundle CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
