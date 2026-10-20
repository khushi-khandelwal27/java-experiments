<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Secure Checkout - ShopSphere" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<main class="py-5 bg-light">
    <div class="container">
        <h2 class="fw-bold mb-4 d-flex align-items-center gap-2">
            <i class="bi bi-shield-check text-primary"></i> Checkout & Payment
        </h2>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 small mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/place-order" method="post" id="checkoutForm">
            <div class="row g-4">
                <div class="col-lg-8">
                    <!-- 1. Delivery Address Card -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                        <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                            <span class="badge bg-primary rounded-circle" style="width:28px;height:28px;line-height:18px;">1</span>
                            Delivery Address
                        </h5>

                        <c:choose>
                            <c:when test="${not empty addresses && addresses.size() > 0}">
                                <div class="mb-3">
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="radio" name="addressOption" id="addrSaved" value="saved" checked onchange="toggleAddressMode()">
                                        <label class="form-check-label fw-semibold" for="addrSaved">Select from Saved Addresses</label>
                                    </div>

                                    <div id="savedAddressSection" class="ps-4">
                                        <c:forEach var="addr" items="${addresses}" varStatus="status">
                                            <div class="form-check p-3 rounded-3 border mb-2 bg-light">
                                                <input class="form-check-input" type="radio" name="addressId" id="addr_${addr.addressId}" 
                                                       value="${addr.addressId}" ${status.first ? 'checked' : ''}>
                                                <label class="form-check-label small" for="addr_${addr.addressId}">
                                                    <span class="badge bg-secondary text-uppercase mb-1">${addr.addressType}</span><br>
                                                    <strong>${addr.addressLine}</strong>, ${addr.city}, ${addr.state} - <strong>${addr.pincode}</strong>
                                                </label>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <div class="form-check mt-3 mb-2">
                                        <input class="form-check-input" type="radio" name="addressOption" id="addrNew" value="new" onchange="toggleAddressMode()">
                                        <label class="form-check-label fw-semibold" for="addrNew">Deliver to a New Address</label>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="addressOption" value="new">
                                <p class="text-muted small">Enter your shipping details below:</p>
                            </c:otherwise>
                        </c:choose>

                        <!-- New Address Fields -->
                        <div id="newAddressFields" class="${not empty addresses && addresses.size() > 0 ? 'd-none' : ''} p-3 border rounded-3 bg-light mt-2">
                            <div class="mb-3">
                                <label for="addressLine" class="form-label small fw-semibold">Street Address / House No.</label>
                                <input type="text" class="form-control form-control-sm" id="addressLine" name="addressLine" placeholder="e.g. 104, Sunrise Residency, Sector 5">
                            </div>
                            <div class="row g-2 mb-3">
                                <div class="col-md-5">
                                    <label for="city" class="form-label small fw-semibold">City</label>
                                    <input type="text" class="form-control form-control-sm" id="city" name="city" placeholder="e.g. Jaipur">
                                </div>
                                <div class="col-md-4">
                                    <label for="state" class="form-label small fw-semibold">State</label>
                                    <input type="text" class="form-control form-control-sm" id="state" name="state" value="Rajasthan">
                                </div>
                                <div class="col-md-3">
                                    <label for="pincode" class="form-label small fw-semibold">Pincode</label>
                                    <input type="text" class="form-control form-control-sm" id="pincode" name="pincode" placeholder="e.g. 302001">
                                </div>
                            </div>
                            <div class="mb-2">
                                <label class="form-label small fw-semibold">Address Type</label>
                                <div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="addressType" id="typeHome" value="HOME" checked>
                                        <label class="form-check-label small" for="typeHome">Home</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="addressType" id="typeOffice" value="OFFICE">
                                        <label class="form-check-label small" for="typeOffice">Office / Commercial</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 2. Payment Method Card -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                        <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                            <span class="badge bg-primary rounded-circle" style="width:28px;height:28px;line-height:18px;">2</span>
                            Payment Method
                        </h5>

                        <!-- Payment Method Option 1: COD -->
                        <div class="p-3 rounded-3 border mb-3 bg-light">
                            <div class="form-check d-flex align-items-center justify-content-between">
                                <div>
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="payCOD" value="COD" checked onchange="handlePaymentMethodChange()">
                                    <label class="form-check-label ms-2 fw-semibold" for="payCOD">
                                        Cash on Delivery (COD)
                                    </label>
                                    <div class="text-muted small ps-4">Pay with cash or scan QR upon doorstep delivery</div>
                                </div>
                                <i class="bi bi-cash-coin fs-2 text-secondary me-2"></i>
                            </div>
                            <div id="codDetailsPanel" class="mt-3 ps-4 border-top pt-2">
                                <div class="alert alert-info py-2 px-3 small rounded-3 mb-0 d-flex align-items-center gap-2">
                                    <i class="bi bi-info-circle-fill fs-5"></i>
                                    <span>Zero advance payment needed. You can inspect your package and pay cash or UPI to the courier agent.</span>
                                </div>
                            </div>
                        </div>

                        <!-- Payment Method Option 2: UPI -->
                        <div class="p-3 rounded-3 border mb-3 bg-light">
                            <div class="form-check d-flex align-items-center justify-content-between">
                                <div>
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="payUPI" value="UPI" onchange="handlePaymentMethodChange()">
                                    <label class="form-check-label ms-2 fw-semibold" for="payUPI">
                                        UPI & Instant QR Payment
                                    </label>
                                    <div class="text-muted small ps-4">Google Pay, PhonePe, Paytm, BHIM, CRED</div>
                                </div>
                                <i class="bi bi-qr-code-scan fs-2 text-primary me-2"></i>
                            </div>

                            <div id="upiDetailsPanel" class="mt-3 ps-4 border-top pt-3 d-none">
                                <div class="row g-3 align-items-center">
                                    <div class="col-md-7">
                                        <label for="upiId" class="form-label small fw-semibold">Enter your UPI ID / VPA</label>
                                        <div class="input-group input-group-sm mb-2">
                                            <span class="input-group-text bg-white"><i class="bi bi-at"></i></span>
                                            <input type="text" class="form-control" id="upiId" name="upiId" placeholder="e.g. yourname@okhdfcbank" value="customer@okaxis">
                                        </div>
                                        <div class="d-flex flex-wrap gap-1 mb-2">
                                            <span class="badge bg-white text-dark border pointer" role="button" onclick="appendUpiSuffix('@oksbi')">@oksbi</span>
                                            <span class="badge bg-white text-dark border pointer" role="button" onclick="appendUpiSuffix('@okhdfcbank')">@okhdfcbank</span>
                                            <span class="badge bg-white text-dark border pointer" role="button" onclick="appendUpiSuffix('@paytm')">@paytm</span>
                                            <span class="badge bg-white text-dark border pointer" role="button" onclick="appendUpiSuffix('@ybl')">@ybl</span>
                                        </div>
                                        <div class="text-muted small" style="font-size: 0.8rem;">
                                            <i class="bi bi-shield-check text-success me-1"></i>A payment request will be sent to your UPI app.
                                        </div>
                                    </div>

                                    <div class="col-md-5 text-center border-start ps-3">
                                        <div class="small fw-semibold text-secondary mb-1">Instant QR Code</div>
                                        <div class="p-2 bg-white d-inline-block rounded-3 border shadow-sm">
                                            <!-- SVG Simulated QR Code -->
                                            <svg width="90" height="90" viewBox="0 0 100 100" fill="#1e293b">
                                                <rect x="0" y="0" width="30" height="30" fill="#0f172a"/>
                                                <rect x="5" y="5" width="20" height="20" fill="#ffffff"/>
                                                <rect x="9" y="9" width="12" height="12" fill="#2563eb"/>
                                                
                                                <rect x="70" y="0" width="30" height="30" fill="#0f172a"/>
                                                <rect x="75" y="5" width="20" height="20" fill="#ffffff"/>
                                                <rect x="79" y="9" width="12" height="12" fill="#2563eb"/>

                                                <rect x="0" y="70" width="30" height="30" fill="#0f172a"/>
                                                <rect x="5" y="75" width="20" height="20" fill="#ffffff"/>
                                                <rect x="9" y="79" width="12" height="12" fill="#2563eb"/>

                                                <rect x="36" y="10" width="8" height="8"/>
                                                <rect x="50" y="10" width="8" height="8"/>
                                                <rect x="36" y="24" width="12" height="12"/>
                                                <rect x="10" y="38" width="14" height="14"/>
                                                <rect x="30" y="42" width="40" height="20" fill="#2563eb" rx="2"/>
                                                <rect x="76" y="38" width="14" height="14"/>
                                                <rect x="42" y="70" width="16" height="16"/>
                                                <rect x="65" y="65" width="12" height="12"/>
                                                <rect x="80" y="80" width="10" height="10"/>
                                            </svg>
                                        </div>
                                        <div class="text-muted" style="font-size: 0.72rem;">Scan with PhonePe, GPay, Paytm</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Payment Method Option 3: Card -->
                        <div class="p-3 rounded-3 border bg-light">
                            <div class="form-check d-flex align-items-center justify-content-between">
                                <div>
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="payCard" value="CARD" onchange="handlePaymentMethodChange()">
                                    <label class="form-check-label ms-2 fw-semibold" for="payCard">
                                        Credit / Debit Card
                                    </label>
                                    <div class="text-muted small ps-4">Visa, Mastercard, RuPay, Maestro</div>
                                </div>
                                <div class="d-flex gap-1 text-secondary fs-4 me-2">
                                    <i class="bi bi-credit-card-2-front text-success"></i>
                                </div>
                            </div>

                            <div id="cardDetailsPanel" class="mt-3 ps-4 border-top pt-3 d-none">
                                <div class="row g-2 mb-2">
                                    <div class="col-12">
                                        <label for="cardNumber" class="form-label small fw-semibold">Card Number</label>
                                        <div class="input-group input-group-sm">
                                            <span class="input-group-text bg-white"><i class="bi bi-credit-card"></i></span>
                                            <input type="text" class="form-control font-monospace" id="cardNumber" name="cardNumber" 
                                                   placeholder="4532 8910 2345 6789" maxlength="19" oninput="formatCardNumber(this)" value="4532 8910 2345 8899">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="cardHolder" class="form-label small fw-semibold">Cardholder Name</label>
                                        <input type="text" class="form-control form-control-sm" id="cardHolder" name="cardHolder" 
                                               placeholder="Name as on Card" value="${sessionScope.user.name}">
                                    </div>
                                    <div class="col-6 col-md-3">
                                        <label for="cardExpiry" class="form-label small fw-semibold">Expiry (MM/YY)</label>
                                        <input type="text" class="form-control form-control-sm font-monospace" id="cardExpiry" name="cardExpiry" 
                                               placeholder="12/28" maxlength="5" value="08/29">
                                    </div>
                                    <div class="col-6 col-md-3">
                                        <label for="cardCvv" class="form-label small fw-semibold">CVV</label>
                                        <input type="password" class="form-control form-control-sm font-monospace" id="cardCvv" name="cardCvv" 
                                               placeholder="•••" maxlength="4" value="882">
                                    </div>
                                </div>
                                <div class="text-muted small d-flex align-items-center gap-1" style="font-size: 0.78rem;">
                                    <i class="bi bi-shield-lock-fill text-success"></i> 256-bit bank-grade encryption with RBI tokenization compliance.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 3. Sidebar Order Review & Coupons -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                        <h5 class="fw-bold mb-3 d-flex align-items-center gap-2">
                            <i class="bi bi-tag-fill text-primary"></i> Coupons & Offers
                        </h5>
                        
                        <div class="input-group mb-3">
                            <input type="text" class="form-control text-uppercase" id="couponCode" name="couponCode" placeholder="Enter coupon code">
                            <button class="btn btn-outline-primary fw-semibold" type="button" onclick="applyCouponManually()">Apply</button>
                        </div>

                        <div id="couponFeedback" class="small mb-2 d-none"></div>

                        <div class="small text-muted mb-2 fw-semibold">Click to apply available promo:</div>
                        <div class="d-flex flex-column gap-2 mb-2">
                            <c:forEach var="c" items="${coupons}">
                                <div class="border rounded-3 p-2 bg-light d-flex justify-content-between align-items-center">
                                    <div>
                                        <strong class="text-primary text-uppercase">${c.code}</strong>
                                        <div class="text-muted" style="font-size: 0.75rem;">
                                            ${c.discountType == 'PERCENT' ? c.discountValue.intValue().toString().concat('% OFF up to ₹').concat(c.maximumDiscount.intValue().toString()) : 'Flat ₹'.concat(c.discountValue.intValue().toString()).concat(' OFF')} (Min order ₹${c.minimumOrder.intValue()})
                                        </div>
                                    </div>
                                    <button type="button" class="btn btn-sm btn-outline-primary rounded-pill px-3" 
                                            onclick="selectCoupon('${c.code}', '${c.discountType}', ${c.discountValue}, ${c.minimumOrder}, ${c.maximumDiscount})">
                                        Use
                                    </button>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Order Total Card -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                        <h5 class="fw-bold mb-3">Order Summary (${cartItems.size()} items)</h5>
                        
                        <div class="d-flex justify-content-between mb-2 small">
                            <span class="text-muted">Subtotal:</span>
                            <span class="fw-bold">₹<fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></span>
                        </div>

                        <div class="d-flex justify-content-between mb-2 small text-danger d-none" id="summaryDiscountRow">
                            <span>Coupon Discount:</span>
                            <span class="fw-bold" id="summaryDiscountAmount">- ₹0.00</span>
                        </div>

                        <div class="d-flex justify-content-between mb-2 small">
                            <span class="text-muted">Delivery & Packing:</span>
                            <span class="text-success fw-bold">FREE</span>
                        </div>

                        <div class="d-flex justify-content-between mb-2 small">
                            <span class="text-muted">GST (18% inclusive):</span>
                            <span class="text-muted fw-semibold">Included</span>
                        </div>

                        <hr class="my-3">

                        <div class="d-flex justify-content-between mb-4">
                            <span class="fs-5 fw-bold">Total Payable:</span>
                            <span class="fs-5 fw-extrabold text-primary" id="summaryPayableAmount">₹<fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></span>
                        </div>

                        <button type="submit" class="btn btn-shopsphere btn-lg w-100 py-3 fw-bold shadow">
                            <i class="bi bi-shield-lock-fill me-2"></i> Confirm & Pay Now
                        </button>
                        <div class="text-center text-muted small mt-2" style="font-size: 0.75rem;">
                            <i class="bi bi-check2-circle text-success me-1"></i>100% Buyer Protection & Easy Returns
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</main>

<script>
var baseSubtotal = ${subtotal};
var currentDiscount = 0.0;

var availableCoupons = [
<c:forEach var="c" items="${coupons}" varStatus="status">
    {
        code: "${c.code}",
        type: "${c.discountType}",
        value: ${c.discountValue},
        minOrder: ${c.minimumOrder},
        maxDiscount: ${c.maximumDiscount}
    }${!status.last ? ',' : ''}
</c:forEach>
];

function toggleAddressMode() {
    var isNew = document.getElementById('addrNew') && document.getElementById('addrNew').checked;
    var newFields = document.getElementById('newAddressFields');
    var savedSec = document.getElementById('savedAddressSection');
    if (newFields) {
        if (isNew) {
            newFields.classList.remove('d-none');
            if (savedSec) savedSec.classList.add('opacity-50');
        } else {
            newFields.classList.add('d-none');
            if (savedSec) savedSec.classList.remove('opacity-50');
        }
    }
}

function handlePaymentMethodChange() {
    var isCod = document.getElementById('payCOD') && document.getElementById('payCOD').checked;
    var isUpi = document.getElementById('payUPI') && document.getElementById('payUPI').checked;
    var isCard = document.getElementById('payCard') && document.getElementById('payCard').checked;

    var codPanel = document.getElementById('codDetailsPanel');
    var upiPanel = document.getElementById('upiDetailsPanel');
    var cardPanel = document.getElementById('cardDetailsPanel');

    if (codPanel) codPanel.classList.toggle('d-none', !isCod);
    if (upiPanel) upiPanel.classList.toggle('d-none', !isUpi);
    if (cardPanel) cardPanel.classList.toggle('d-none', !isCard);
}

function appendUpiSuffix(suffix) {
    var input = document.getElementById('upiId');
    if (input) {
        var val = input.value.split('@')[0];
        if (!val) val = "customer";
        input.value = val + suffix;
    }
}

function formatCardNumber(input) {
    var val = input.value.replace(/\D/g, '').substring(0, 16);
    var formatted = val.match(/.{1,4}/g)?.join(' ') || val;
    input.value = formatted;
}

function selectCoupon(code, type, value, minOrder, maxDiscount) {
    document.getElementById('couponCode').value = code;
    applyCouponCalculation(code, type, value, minOrder, maxDiscount);
}

function applyCouponManually() {
    var inputCode = document.getElementById('couponCode').value.trim().toUpperCase();
    if (!inputCode) {
        showCouponFeedback("Please enter a coupon code.", "danger");
        return;
    }
    var found = availableCoupons.find(function(c) { return c.code === inputCode; });
    if (found) {
        applyCouponCalculation(found.code, found.type, found.value, found.minOrder, found.maxDiscount);
    } else {
        showCouponFeedback("Invalid or expired coupon code: " + inputCode, "danger");
    }
}

function applyCouponCalculation(code, type, value, minOrder, maxDiscount) {
    if (baseSubtotal < minOrder) {
        showCouponFeedback("Coupon '" + code + "' requires minimum order of ₹" + minOrder.toFixed(2), "warning");
        resetCouponSummary();
        return;
    }
    var discount = 0.0;
    if (type === 'PERCENT') {
        discount = baseSubtotal * (value / 100.0);
        if (discount > maxDiscount) discount = maxDiscount;
    } else {
        discount = value;
    }
    discount = Math.round(discount * 100.0) / 100.0;
    currentDiscount = discount;

    var finalPayable = Math.max(0, baseSubtotal - discount);

    var discountRow = document.getElementById('summaryDiscountRow');
    var discountAmount = document.getElementById('summaryDiscountAmount');
    var payableAmount = document.getElementById('summaryPayableAmount');

    if (discountRow) discountRow.classList.remove('d-none');
    if (discountAmount) discountAmount.textContent = "- ₹" + discount.toLocaleString('en-IN', {minimumFractionDigits: 2});
    if (payableAmount) payableAmount.textContent = "₹" + finalPayable.toLocaleString('en-IN', {minimumFractionDigits: 2});

    showCouponFeedback("Success! Coupon '" + code + "' applied. You saved ₹" + discount.toFixed(2) + "!", "success");
}

function resetCouponSummary() {
    currentDiscount = 0.0;
    var discountRow = document.getElementById('summaryDiscountRow');
    var payableAmount = document.getElementById('summaryPayableAmount');
    if (discountRow) discountRow.classList.add('d-none');
    if (payableAmount) payableAmount.textContent = "₹" + baseSubtotal.toLocaleString('en-IN', {minimumFractionDigits: 2});
}

function showCouponFeedback(msg, type) {
    var fb = document.getElementById('couponFeedback');
    if (fb) {
        fb.className = "small mb-2 alert alert-" + type + " py-1 px-2 rounded-2";
        fb.textContent = msg;
    }
}
</script>

<%@ include file="/fragments/footer.jsp" %>
