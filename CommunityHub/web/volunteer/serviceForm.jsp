<%@page import="com.cm.model.events"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Feedback Report</title>
    </head>
    <body>
        <%
            String name = (String) request.getAttribute("eventName");
            int id = (Integer) request.getAttribute("eventID");
            int volunteerId = (Integer) request.getSession().getAttribute("volunteer");
                                    
        %>
        <%@ include file="../header.jspf" %>
        <div class="container mt-4 pb-3 border w-50 w-md-75 rounded-4 shadow" style="background-color:#3A7CA5;">
            <div class="container">
                <div class="row text-center">
                    <h1 class="fw-bolder text-white my-3" style="text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3);">Service Report</h1>
                </div>
                <form class="needs-validation" method="post" action="<%=request.getContextPath()%>/addservice.do" novalidate>
                    <div class="row border mb-3 mx-3 rounded-4 bg-white gy-2 p-3">
                        <div class="col-12 col-md">
                            <label for="eventMenu" class="form-label">Event</label>
                            <select class="form-select" id="eventMenu" name="eventMenu" aria-label="Default select example" required>
                                <option selected value="<%= id %>"><%= name %></option>
                            </select>
                            <div class="invalid-feedback">
                                Please select an event.
                            </div>
                        </div>
                        <div class="col-12 col-md">
                            <label for="volunteer" class="form-label">Volunteer ID</label>
                            <input type="text" class="form-control" id="volunteer" name="volunteer" value="<%= volunteerId %>" readonly>
                            <div class="invalid-feedback">
                                Insert ID
                            </div>
                        </div>
                        <div class="col-12">
                            <label for="challenge" class="form-label">Challenge during Event</label>
                            <input type="text" class="form-control" id="challenge" name="challenge" minlength="10" required>
                            <div class="invalid-feedback">
                                Please provide a challenge description of at least 10 characters.
                            </div>
                        </div>
                        <div class="col-12">
                            <label for="solution" class="form-label">Suggest Solution</label>
                            <input type="text" class="form-control" id="solution" name="solution" minlength="10" required>
                            <div class="invalid-feedback">
                                Please provide a solution description of at least 10 characters.
                            </div>
                        </div>
                        <div class="col-12">
                            <label for="feedback" class="form-label">Other Feedback</label>
                            <input type="text" class="form-control" id="feedback" name="feedback">
                            <div class="invalid-feedback">
                                Please provide feedback of at least 10 characters.
                            </div>
                        </div>
                        <div class="col-12">
                            <label for="recommend" class="form-label">Recommendations</label>
                            <input type="text" class="form-control" id="recommend" name="recommend" minlength="10" required>
                            <div class="invalid-feedback">
                                Please provide recommendations of at least 10 characters.
                            </div>
                        </div>
                        <div class="col-12 mt-3">
                            <button type="submit" class="btn btn-primary w-100 text-center" style="background-color:#2F6690;border-color: #2F6690;">Submit</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <script>
            (() => {
                'use strict';

                const forms = document.querySelectorAll('.needs-validation');

                // Loop over all forms and add the custom validation
                Array.from(forms).forEach(form => {
                    form.addEventListener('submit', event => {
                        if (!form.checkValidity()) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });

                // Real-time validation for minimum length
                const challengeInput = document.getElementById('challenge');
                const solutionInput = document.getElementById('solution');
                const feedbackInput = document.getElementById('feedback');
                const recommendInput = document.getElementById('recommend');

                const validateLength = (input) => {
                    if (input.value.length < 10) {
                        input.classList.add('is-invalid');
                        input.classList.remove('is-valid');
                    } else {
                        input.classList.remove('is-invalid');
                        input.classList.add('is-valid');
                    }
                };

                // Add event listeners for each field
                challengeInput.addEventListener('input', () => validateLength(challengeInput));
                solutionInput.addEventListener('input', () => validateLength(solutionInput));
                feedbackInput.addEventListener('input', () => validateLength(feedbackInput));
                recommendInput.addEventListener('input', () => validateLength(recommendInput));
            })();
        </script>
    </body>
</html>