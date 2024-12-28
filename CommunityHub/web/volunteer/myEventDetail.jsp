<%-- 
    Document   : myEventDetail
    Created on : Dec 22, 2024, 11:48:23 PM
    Author     : Rina
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Event Detail</title>
        <link rel="stylesheet" href="styles.css"> <!-- Link to CSS file -->
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
         <style>
            body {
                font-family: 'Poppins', sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f8f9fa;
            }

            .container {
                margin: 15px;
            }

            .event-image {
                width: 350px; /* Set the width */
                height: auto; /* Keep the aspect ratio */
                margin: 10px
            }

            .divider {
                height: 1px; 
                width: 95%; /* Set width to 80% of the screen size */
                background-color: black; 
                margin: 0 auto; /* Center the divider horizontally */
            }

            .progress-bar {
                background-color: pink;
            }

            .donate-btn {
                background-color: #000; /* Black button */
                color: #fff; /* White text */
                border-radius: 30px; /* Rounded edges */
            }
            
            .card {
                border-radius: 10px; 
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            .modal-dialog.custom-width {
                max-width: 80%; /* Set your desired width */
            }


        </style>
        </head>
        <body>
            <%@ include file="../header.jspf" %>
            <img src="assets/gotong_royong.png" class="rounded mx-auto d-block event-image font-weight-bold" alt="Event Image">
            <figure class="text-center">
                <blockquote class="blockquote">
                  <p class="h6">GOTONG-ROYONG UITM KUALA TERENGGANU.</p>
                </blockquote>
                <figcaption class="blockquote-footer">
                  BY <cite title="Beneficiary Name">@BeneficiaryName</cite>
                </figcaption>
            </figure>
            <div class="divider"></div>
            <div class="container">
    <div class="row">
        <!-- Left Column: About, Location, and Event Date -->
        <div class="col-md-8">
            <p><strong>About</strong></p>
            <p>
                Veniam quae. Nostrum facere repellendus minus quod aut aliquam neque reiciendis. 
                Qui beatae vel magnam repudiandae ipsum repellat repudiandae. 
                Voluptate at dolores ut dolor sint occaecati similique. Velit eius ab delectus temporibus.
            </p>
            <p>
                For dynamic content, add a rich text field to any collection and then connect a rich text element 
                to that field in the settings panel. Headings, paragraphs, block-quotes, figures, images, 
                and figure captions can all be styled.
            </p>

            <p><strong>Location</strong></p>
            <div class="d-flex align-items-start justify-content-start">
                <i class="bi bi-geo-alt-fill text-danger me-2"></i>
                <p class="text-muted">UiTM Chendering, Kuala Terengganu.</p>
            </div>

            <p><strong>Event Date</strong></p>
            <div class="d-flex justify-content-between mb-3">
                <small>
                    Start Date
                    <br>
                    <div class="d-flex align-items-start justify-content-start">
                        <i class="bi bi-calendar-event me-2"></i>
                        <p class="text-muted">Dec 21, 2024 (8:00 p.m)</p>
                    </div>
                </small>
                <small>
                    End Date
                    <br>
                    <div class="d-flex align-items-start justify-content-start">
                        <i class="bi bi-calendar-event me-2"></i>
                        <p class="text-muted">Dec 21, 2026 (8:00 p.m)</p>
                    </div>
                </small>
            </div>
        </div>

        <!-- Right Column: Cards -->
        <div class="col-md-4">
            <!-- First Card -->
            <div class="card mb-4" style="border-radius: 10px;">
                <div class="card-body text-center">
                    <div class="d-flex align-items-center justify-content-center">
                    <img src="assets\Medallions.svg" alt="Icon" style="width: 50px; height: 50px;">
                    <p><strong>DOWNLOAD CERTIFICATE</strong></p>
                    </div>
                    <button class="btn w-100 py-2" style="background-color: #000; color: #fff; border-radius: 30px;" type="button" data-bs-toggle="modal" data-bs-target="#certificateModal">
                        DOWNLOAD <i class="bi bi-download"></i>
                    </button>

                    <div class="modal fade" id="certificateModal" tabindex="-1" aria-labelledby="certificateModalLabel" aria-hidden="true">
                        <div class="modal-dialog custom-width">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="certificateModalLabel">Certificate</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <%@ include file="certificate.jsp" %>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
            

            <!-- Second Card -->
            <div class="card mb-4" style="border-radius: 10px;">
                <div class="card-body text-center">
                    <div class="d-flex align-items-center justify-content-center">
                    <img src="assets\medal.svg" alt="Icon" style="width: 50px; height: 50px;">
                    <p><strong>SERVICE REPORT</strong></p>
                    </div>
                    <p class="card-text text-muted">
                        Tell us about your experience and suggestions to improve our service and enhance our system.
                    </p>
                    <a href="serviceForm.jsp" class="btn w-100 py-2" style="background-color: #000; color: #fff; border-radius: 30px;">
                        FILL IN FORM? <i class="bi bi-pencil-square"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>


    </body>
</html>

