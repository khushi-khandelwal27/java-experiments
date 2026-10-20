<%@ tag description="Star Rating Component" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ attribute name="value" type="java.lang.Double" required="true" %>
<%@ attribute name="count" type="java.lang.Integer" required="false" %>

<div class="d-inline-flex align-items-center gap-1 text-warning">
    <c:forEach var="i" begin="1" end="5">
        <c:choose>
            <c:when test="${value >= i}">
                <i class="bi bi-star-fill"></i>
            </c:when>
            <c:when test="${value >= (i - 0.5)}">
                <i class="bi bi-star-half"></i>
            </c:when>
            <c:otherwise>
                <i class="bi bi-star text-muted opacity-50"></i>
            </c:otherwise>
        </c:choose>
    </c:forEach>
    <span class="ms-1 fw-bold text-dark small"><fmt:formatNumber value="${value}" pattern="0.0"/></span>
    <c:if test="${not empty count && count > 0}">
        <span class="text-muted small">(${count})</span>
    </c:if>
</div>
