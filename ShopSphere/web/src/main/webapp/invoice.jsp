<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tax Invoice #INV-SPH-${order.orderId} - ShopSphere</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #f3f4f6;
            color: #1f2937;
        }
        .invoice-card {
            background: #ffffff;
            border-radius: 1rem;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
        }
        .mono {
            font-family: 'JetBrains Mono', monospace;
        }
        .stamp-paid {
            border: 3px solid #16a34a;
            color: #16a34a;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 2px;
            padding: 0.35rem 1.25rem;
            display: inline-block;
            border-radius: 0.5rem;
            transform: rotate(-5deg);
            opacity: 0.85;
        }
        .stamp-pending {
            border: 3px solid #ca8a04;
            color: #ca8a04;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 2px;
            padding: 0.35rem 1.25rem;
            display: inline-block;
            border-radius: 0.5rem;
            transform: rotate(-5deg);
            opacity: 0.85;
        }
        @media print {
            body {
                background-color: #ffffff;
                color: #000000;
                font-size: 12px;
            }
            .no-print {
                display: none !important;
            }
            .invoice-card {
                box-shadow: none !important;
                border: 1px solid #e5e7eb !important;
                padding: 1.5rem !important;
            }
        }
    </style>
</head>
<body class="py-4 py-md-5">

<div class="container" style="max-width: 900px;">
    <!-- Top Action Bar (hidden in print) -->
    <div class="d-flex justify-content-between align-items-center mb-4 no-print">
        <a href="${pageContext.request.contextPath}/order-details?id=${order.orderId}" class="btn btn-outline-secondary rounded-pill px-3 py-2 small">
            <i class="bi bi-arrow-left me-1"></i> Back to Order Tracking
        </a>
        <div class="d-flex gap-2">
            <button onclick="window.print()" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold shadow-sm">
                <i class="bi bi-printer-fill me-1"></i> Print / Save as PDF
            </button>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-light border rounded-pill px-3 py-2 small">
                <i class="bi bi-bag me-1"></i> Shop More
            </a>
        </div>
    </div>

    <!-- Invoice Paper Container -->
    <div class="invoice-card p-4 p-md-5">
        <!-- Header -->
        <div class="row align-items-start border-bottom pb-4 mb-4">
            <div class="col-sm-7">
                <div class="d-flex align-items-center gap-2 mb-2">
                    <span class="fs-2 fw-extrabold text-primary"><i class="bi bi-bag-check-fill me-1"></i>ShopSphere</span>
                </div>
                <div class="small text-muted">
                    <strong>ShopSphere E-Commerce Private Limited</strong><br>
                    Corporate Tower B, Tech Zone 4, Sitapura Industrial Area<br>
                    Jaipur, Rajasthan - 302022, India<br>
                    <strong>GSTIN:</strong> 08AAECS9281M1Z5 | <strong>CIN:</strong> U72900RJ2026PTC049281<br>
                    <strong>Support:</strong> care@shopsphere.com | +91 141 278 9900
                </div>
            </div>
            <div class="col-sm-5 text-sm-end mt-3 mt-sm-0">
                <h3 class="fw-bold text-uppercase text-secondary mb-1">Tax Invoice</h3>
                <div class="mono small text-muted">Original for Recipient</div>
                <div class="mt-3">
                    <div class="small text-muted">Invoice No:</div>
                    <div class="fw-bold mono fs-6 text-primary">#INV-2026-SPH-${order.orderId}</div>
                    <div class="small text-muted mt-1">Invoice Date:</div>
                    <div class="fw-semibold small"><fmt:formatDate value="${order.createdAt}" pattern="dd MMMM yyyy, hh:mm a"/></div>
                </div>
            </div>
        </div>

        <!-- Billing & Shipping Information -->
        <div class="row g-4 mb-4 pb-4 border-bottom">
            <div class="col-sm-6">
                <h6 class="text-uppercase text-secondary fw-bold small mb-2"><i class="bi bi-person-fill text-primary me-1"></i> Billed To:</h6>
                <div class="fw-bold fs-6">${not empty order.userName ? order.userName : sessionScope.user.name}</div>
                <div class="small text-muted">${not empty order.userEmail ? order.userEmail : sessionScope.user.email}</div>
                <c:if test="${not empty sessionScope.user.mobile}">
                    <div class="small text-muted">Phone: +91 ${sessionScope.user.mobile}</div>
                </c:if>
            </div>
            <div class="col-sm-6">
                <h6 class="text-uppercase text-secondary fw-bold small mb-2"><i class="bi bi-geo-alt-fill text-primary me-1"></i> Delivered & Shipped To:</h6>
                <c:choose>
                    <c:when test="${not empty order.address}">
                        <div class="fw-semibold small">
                            <span class="badge bg-secondary mb-1">${order.address.addressType}</span><br>
                            ${order.address.addressLine}<br>
                            ${order.address.city}, ${order.address.state} - <strong>${order.address.pincode}</strong>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="small text-muted">Express Registered Delivery Address</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Items Table -->
        <div class="table-responsive mb-4">
            <table class="table table-bordered align-middle">
                <thead class="table-light small text-secondary">
                    <tr>
                        <th style="width: 5%;">#</th>
                        <th style="width: 45%;">Item Description</th>
                        <th class="text-center" style="width: 12%;">HSN/SAC</th>
                        <th class="text-center" style="width: 10%;">Qty</th>
                        <th class="text-end" style="width: 14%;">Unit Price</th>
                        <th class="text-end" style="width: 14%;">Amount (₹)</th>
                    </tr>
                </thead>
                <tbody class="small">
                    <c:forEach var="item" items="${order.items}" varStatus="status">
                        <tr>
                            <td>${status.index + 1}</td>
                            <td>
                                <strong>${item.product.name}</strong>
                                <c:if test="${not empty item.product.brand}">
                                    <div class="text-muted text-uppercase" style="font-size: 0.75rem;">Brand: ${item.product.brand}</div>
                                </c:if>
                            </td>
                            <td class="text-center mono text-muted">847130</td>
                            <td class="text-center">${item.quantity}</td>
                            <td class="text-end mono">₹<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
                            <td class="text-end mono fw-bold">₹<fmt:formatNumber value="${item.subTotal}" pattern="#,##0.00"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Summary & Tax Breakdown -->
        <div class="row align-items-center mb-4">
            <div class="col-md-6 mb-3 mb-md-0">
                <div class="p-3 bg-light rounded-3">
                    <h6 class="fw-bold small text-secondary mb-2"><i class="bi bi-credit-card-2-back-fill text-success me-1"></i> Payment Transaction Record</h6>
                    <div class="small mb-1">
                        <span class="text-muted">Payment Mode:</span>
                        <strong class="text-dark">${order.paymentMethod}</strong>
                    </div>
                    <div class="small mb-1">
                        <span class="text-muted">Transaction / UTR Ref:</span>
                        <span class="mono fw-semibold text-primary">
                            ${not empty order.payment && not empty order.payment.transactionReference ? order.payment.transactionReference : (order.paymentMethod == 'COD' ? 'COD-VERIFIED' : 'TXN-PAID')}
                        </span>
                    </div>
                    <div class="small mb-2">
                        <span class="text-muted">Payment Status:</span>
                        <span class="badge ${order.paymentStatus == 'COMPLETED' ? 'bg-success' : 'bg-warning text-dark'}">${order.paymentStatus}</span>
                    </div>
                    <div class="mt-3">
                        <c:choose>
                            <c:when test="${order.paymentStatus == 'COMPLETED'}">
                                <div class="stamp-paid">PAID & VERIFIED</div>
                            </c:when>
                            <c:otherwise>
                                <div class="stamp-pending">PAYMENT PENDING (COD)</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <table class="table table-sm table-borderless small mb-0">
                    <tr>
                        <td class="text-muted">Gross Taxable Value:</td>
                        <td class="text-end mono">₹<fmt:formatNumber value="${taxableAmount}" pattern="#,##0.00"/></td>
                    </tr>
                    <tr>
                        <td class="text-muted">CGST (9.0%):</td>
                        <td class="text-end mono">₹<fmt:formatNumber value="${cgst}" pattern="#,##0.00"/></td>
                    </tr>
                    <tr>
                        <td class="text-muted">SGST (9.0%):</td>
                        <td class="text-end mono">₹<fmt:formatNumber value="${sgst}" pattern="#,##0.00"/></td>
                    </tr>
                    <c:if test="${order.discount > 0}">
                        <tr class="text-danger fw-semibold">
                            <td>Coupon Discount:</td>
                            <td class="text-end mono">- ₹<fmt:formatNumber value="${order.discount}" pattern="#,##0.00"/></td>
                        </tr>
                    </c:if>
                    <tr>
                        <td class="text-muted">Delivery & Shipping:</td>
                        <td class="text-end text-success fw-bold">FREE</td>
                    </tr>
                    <tr class="border-top border-dark">
                        <td class="fw-bold fs-6">Grand Total (Incl. GST):</td>
                        <td class="text-end fs-5 fw-extrabold text-primary mono">
                            ₹<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/>
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <!-- Footer / Declaration -->
        <div class="border-top pt-3 mt-4 small text-muted">
            <div class="row">
                <div class="col-sm-8">
                    <strong>Declaration:</strong> This is a computer-generated tax invoice issued in accordance with Section 31 of the Central Goods and Services Tax Act, 2017. Goods sold are intended for end-user consumption. No signature required.
                </div>
                <div class="col-sm-4 text-sm-end mt-2 mt-sm-0">
                    <div class="fw-bold text-dark">Authorized Signatory</div>
                    <div class="small">ShopSphere Billing Desk</div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
