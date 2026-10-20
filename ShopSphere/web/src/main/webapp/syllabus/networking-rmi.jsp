<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Sockets & RMI Architecture - RTU Syllabus Demo" scope="request"/>
<%@ include file="/fragments/header.jsp" %>
<%@ include file="/fragments/navbar.jsp" %>

<main class="py-5">
    <div class="container">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb small">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                <li class="breadcrumb-item active">Syllabus Demo: java.net Sockets & Java RMI</li>
            </ol>
        </nav>

        <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
            <div class="d-flex align-items-center gap-3 mb-3">
                <div class="p-3 bg-purple-subtle text-primary rounded-3 fs-3" style="background-color: #ede9fe;">
                    <i class="bi bi-diagram-3-fill"></i>
                </div>
                <div>
                    <h2 class="fw-bold mb-0">Distributed Computing: Sockets & Java RMI</h2>
                    <p class="text-muted mb-0">RTU Syllabus Topic: java.net ServerSocket/Socket, RMI Registry, Remote Interfaces & Serialization</p>
                </div>
            </div>

            <hr class="my-4">

            <div class="row g-4">
                <!-- 1. Networking Module -->
                <div class="col-lg-6">
                    <div class="card bg-light border-0 rounded-4 p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold text-primary mb-0"><i class="bi bi-ethernet me-2"></i>1. java.net Socket Server</h5>
                            <span class="badge bg-primary">Port: 5050</span>
                        </div>
                        <p class="text-secondary small">
                            TCP Client-Server communication using <code>ServerSocket.accept()</code>, <code>Socket</code> streams, and Object Serialization to query live inventory.
                        </p>

                        <div class="p-3 bg-white rounded-3 border mb-3 small">
                            <strong>Supported Socket Commands:</strong>
                            <ul class="mb-0 mt-1 ps-3 text-secondary">
                                <li><code>GET_PRODUCT &lt;id&gt;</code> &mdash; Returns serialized Product object</li>
                                <li><code>GET_STOCK &lt;productId&gt;</code> &mdash; Queries current warehouse stock</li>
                                <li><code>SEARCH_PRODUCT &lt;keyword&gt;</code> &mdash; Searches matching catalog items</li>
                                <li><code>UPDATE_STOCK &lt;productId&gt; &lt;units&gt;</code> &mdash; Restocks product</li>
                            </ul>
                        </div>

                        <div class="bg-dark text-white p-3 rounded-3 font-monospace small">
<pre class="mb-0 text-white"><code>// Run via terminal:
run-socket-server.bat
run-socket-client.bat
</code></pre>
                        </div>
                    </div>
                </div>

                <!-- 2. RMI Module -->
                <div class="col-lg-6">
                    <div class="card bg-light border-0 rounded-4 p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold text-success mb-0"><i class="bi bi-cpu-fill me-2"></i>2. Java RMI Registry Service</h5>
                            <span class="badge bg-success">Port: 1099</span>
                        </div>
                        <p class="text-secondary small">
                            Distributed Remote Method Invocation using <code>LocateRegistry.createRegistry()</code>, remote interfaces extending <code>java.rmi.Remote</code>, and <code>UnicastRemoteObject</code>.
                        </p>

                        <div class="p-3 bg-white rounded-3 border mb-3 small">
                            <strong>Remote Interface Methods:</strong>
                            <ul class="mb-0 mt-1 ps-3 text-secondary">
                                <li><code>Product getProduct(int id) throws RemoteException</code></li>
                                <li><code>int getStock(int productId) throws RemoteException</code></li>
                                <li><code>boolean updateStock(int id, int qty) throws RemoteException</code></li>
                                <li><code>List&lt;Product&gt; getAllProducts() throws RemoteException</code></li>
                            </ul>
                        </div>

                        <div class="bg-dark text-white p-3 rounded-3 font-monospace small">
<pre class="mb-0 text-white"><code>// Run via terminal:
run-rmi-server.bat
run-rmi-client.bat
</code></pre>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/fragments/footer.jsp" %>
