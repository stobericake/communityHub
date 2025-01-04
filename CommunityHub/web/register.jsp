<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Signup Screen</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to bottom, #2F6690, #ffffff);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .signup-container {
            background: #ffffff;
            border-radius: 10px;
            padding: 30px;
            width: 100%;
            max-width: 600px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .signup-header {
            text-align: center;
            margin-bottom: 20px;
        }
        .signup-header h1 {
            font-size: 32px;
            font-weight: bold;
            color: #ff5722;
        }
        .signup-header h2 {
            font-size: 24px;
            color: #6c757d;
        }
        .btn-register {
            background-color: #2F6690;
            color: #ffffff;
            font-weight: bold;
        }
        .btn-register:hover {
            background-color: #1E4A68;
        }
    </style>
</head>
<body>
    <div class="signup-container">
        <div class="signup-header">
            <h2>Welcome to</h2>
            <h1 style="color: #2F6690;">CommUNITYHub</h1>
        </div>
        <form action="register" method="post">
            <div class="row mb-3">
                <div class="col-md-6">
                    <input type="text" name="full_name" class="form-control" placeholder="Full Name" required>
                </div>
                <div class="col-md-6">
                    <input type="text" name="username" class="form-control" placeholder="Username" required>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-md-6">
                    <input type="text" name="phone_number" class="form-control" placeholder="Phone Number" required>
                </div>
                <div class="col-md-6">
                    <input type="text" name="street" class="form-control" placeholder="Street" required>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-md-4">
                    <input type="text" name="postcode" class="form-control" placeholder="Postcode" required>
                </div>
                <div class="col-md-4">
                    <input type="text" name="city" class="form-control" placeholder="City" required>
                </div>
                <div class="col-md-4">
                    <input type="text" name="state" class="form-control" placeholder="State" required>
                </div>
            </div>
            <div class="mb-3">
                <input type="text" name="country" class="form-control" placeholder="Country" required>
            </div>
            <div class="row mb-3">
                <div class="col-md-6">
                    <input type="password" name="password" class="form-control" placeholder="Password" required>
                </div>
                <div class="col-md-6">
                    <input type="password" name="confirm_password" class="form-control" placeholder="Confirm Password" required>
                </div>
            </div>
            <div class="row mb-4">
                <div class="col-md-12">
                    <label for="role" class="form-label">I want to register as:</label>
                    <select id="role" name="role" class="form-select" required>
                        <option value="" selected disabled>Select Role</option>
                        <option value="volunteer">Volunteer</option>
                        <option value="beneficiary">Beneficiary</option>
                    </select>
                </div>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-register btn-lg w-100">REGISTER</button>
            </div>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
