<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login Screen</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background: linear-gradient(to bottom, #2F6690, #C3DFE6);
                min-height: 100vh;
            }
            .login-container {
                background: #ffffff;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            .btn-login {
                background-color: #2F6690;
                color: #ffffff;
            }
            .btn-login:hover {
                background-color: #3A7C5;
            }
            .btn-register {
                background-color: #F56476;
                color: #ffffff;
            }
            .btn-register:hover {
                background-color: #e64a19;
            }
        </style>
    </head>
    <body class="d-flex justify-content-center align-items-center flex-column">
        <!-- Logo -->
        <div class="mb-3 text-center">
            <img src="https://via.placeholder.com/80x80?text=Logo" alt="Logo" class="img-fluid">
        </div>

        <!-- Login Container -->
        <div class="login-container text-center w-100" style="max-width: 400px;">
            <h1 class="fw-bold mb-4" style="color:#2F6690;">CommUNITYHub</h1>
            <form>
                <div class="mb-3">
                    <input type="text" class="form-control" placeholder="Username" name="username" required>
                </div>
                <div class="mb-3">
                    <input type="password" class="form-control" placeholder="Password" name="password" required>
                </div>
                <button type="submit" class="btn btn-login btn-lg w-100 mb-3">LOGIN</button>
                <div class="mb-3">
                    <div class="row">
                        <div class="col-6"><a href="#" class="text-decoration-none text-primary">Forgot password?</a></div>
                        <div class="col-6"><a href="#" class="text-decoration-none text-primary">Register</a></div>
                    </div>
                </div>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
