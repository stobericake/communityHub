/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


 
        let currentStep = 1;
        const totalSteps = 5;

        function updateButtons() {
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            
            prevBtn.style.display = currentStep === 1 ? 'none' : 'block';
            
          if (currentStep === totalSteps) {
                nextBtn.textContent = 'Submit';  
            } else {
                nextBtn.textContent = 'Next';
                nextBtn.setAttribute('type', 'button'); 
            }
                    }

        function updateSteps() {
            // Update progress steps
            document.querySelectorAll('.progress-step').forEach((step, index) => {
                const stepNum = index + 1;
                if (stepNum < currentStep) {
                    step.classList.add('completed');
                    step.classList.remove('active');
                } else if (stepNum === currentStep) {
                    step.classList.add('active');
                    step.classList.remove('completed');
                } else {
                    step.classList.remove('completed', 'active');
                }
            });

            // Update progress lines
            document.querySelectorAll('.progress-line').forEach((line, index) => {
                if (index + 1 < currentStep) {
                    line.classList.add('active');
                } else {
                    line.classList.remove('active');
                }
            });

            // Show/hide form sections
            document.querySelectorAll('.form-section').forEach((section) => {
                if (parseInt(section.dataset.step) === currentStep) {
                    section.classList.add('active');
                } else {
                    section.classList.remove('active');
                }
            });

                updateButtons();
            }

           function nextStep() {
                if (currentStep < totalSteps) {
                    currentStep++;
                    updateSteps();
                } 
                else{
                    const nextBtn = document.getElementById('nextBtn');
                        nextBtn.setAttribute('type', 'submit');
                }
            }


            function prevStep() {
                if (currentStep > 1) {
                    currentStep--;
                    updateSteps();
                }
            }
        
                    // Set minimum date to tomorrow
            window.addEventListener('load', function() {
                const tomorrow = new Date();
                tomorrow.setDate(tomorrow.getDate() + 1);
                const formattedDate = tomorrow.toISOString().split('T')[0];
                document.getElementById('eventDate').min = formattedDate;
            });

            // Validate duration inputs
            document.getElementById('durationHours').addEventListener('input', function() {
                if (this.value > 24) this.value = 24;
                if (this.value < 0) this.value = 0;
            });

            document.getElementById('durationMinutes').addEventListener('input', function() {
                if (this.value > 59) this.value = 59;
                if (this.value < 0) this.value = 0;
            });



        // Array to store tasks
        let taskArray = [];
 
        let taskCount = 1;  // Assuming task count starts from 1
        const taskTotal = parseInt(document.getElementById('taskCount').value, 10);

        if(taskTotal !== null){
        taskCount = taskTotal + 1; }
 
        function addCurrentTask(){
        for (let i = 0; i < 2; i++) {
             let taskInputs = document.querySelector('#task\\[' + i + '\\]');
             let taskName = null;
            if (taskInputs !== null) {
                taskName = taskInputs.value.trim(); // Trim whitespace
                taskArray.push(taskName); // Add task name to the array
                
            } 
        }
        }
        
          window.onload = function() {
            addCurrentTask();  
            console.log(taskArray);
          };
        
        

        function addTask(event) {
        // Prevent the form from submitting (which causes the page redirect)
        event.preventDefault();


        const taskInput = document.getElementById('taskInput');
        const taskName = taskInput.value.trim();

        // Validate if task name is empty
        if (!taskName) {
            alert('Task name cannot be empty!');
            return;
        }


        // Create task row
        const taskList = document.getElementById('taskList');
        const row = document.createElement('tr');
        row.innerHTML =
            '<td class="px-4">' + taskCount + '</td>' +
            '<td class="px-4">' +
                '<span class="task-name">' + taskName + '</span>' +
                '<input type="text" class="form-control d-none edit-input" value="' + taskName + '">' +
            '</td>' +
            '<td class="px-4">' +
                '<div class="btn-group btn-group-sm">' +
                    '<button class="btn btn-outline-primary" onclick="editTask(this)">' +
                        '<i class="fas fa-edit"></i>' +
                    '</button>' +
                    '<button class="btn btn-outline-danger" onclick="deleteTask(this)">' +
                        '<i class="fas fa-trash"></i>' +
                    '</button>' +
                '</div>' +
            '</td>';

            // Append the new task to the list
            taskList.appendChild(row);

            // Add the task to the task array
            taskArray.push(taskName);

            // Increment task count and clear the input
            taskCount++;
            taskInput.value = '';
             console.log(taskArray);
        }

            // Edit task
            function editTask(button) {
                   event.preventDefault();
                const row = button.closest('tr');
                const nameSpan = row.querySelector('.task-name');
                const nameInput = row.querySelector('.edit-input');

                if (nameSpan.classList.contains('d-none')) {
                    // Save changes
                    const newName = nameInput.value.trim();
                    if (!newName) {
                        return;
                    }
                    nameSpan.textContent = newName;
                    nameSpan.classList.remove('d-none');
                    nameInput.classList.add('d-none');
                    button.innerHTML = '<i class="fas fa-edit"></i>';

                    // Update the task in the array
                    const taskIndex = Array.from(row.parentElement.children).indexOf(row);
                    taskArray[taskIndex] = newName;  // Update the array with the new task name
                } else {
                    // Show edit input
                    nameSpan.classList.add('d-none');
                    nameInput.classList.remove('d-none');
                    nameInput.focus();
                    button.innerHTML = '<i class="fas fa-save"></i>';
                }
            }

            // Delete task
            function deleteTask(button) {
                   event.preventDefault();
                const row = button.closest('tr');
                const taskList = document.getElementById('taskList');

                if (confirm('Are you sure you want to delete this task?')) {
                    row.remove();
                    taskCount = taskCount - 1;

                    // Remove task from the array
                    const taskIndex = Array.from(row.parentElement.children).indexOf(row);
                    taskArray.splice(taskIndex, 1);

                    // Show empty state if no tasks remain
                    if (taskList.length === 0) {
                     const emptyState = document.getElementById('emptyState');
                        emptyState.style.display = "block";  // Hide the element
                    }
                }
            }
            
                document.addEventListener('DOMContentLoaded', function() {
                var form = document.querySelector('form[action="test.do"][method="POST"][enctype="multipart/form-data"]');


                    form.addEventListener('submit', function(event) {
                        // Clear any existing hidden task inputs
                        var existingTaskInputs = this.querySelectorAll('input[name^="task"]');
                        existingTaskInputs.forEach(function(input) {
                            input.remove();
                        });

                        // Add hidden inputs for each task
                        taskArray.forEach(function(task, index) {
                            var nameInput = document.createElement('input');
                            nameInput.type = 'hidden';
                            nameInput.name = 'task[' + index + '].name';
                            nameInput.value = task;
                            console.log(task);
                            form.appendChild(nameInput);
                        });
                    });
                });