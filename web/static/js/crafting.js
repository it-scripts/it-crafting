var savedRecipes = [];

// Function to render recipes
function renderRecipes(recipes) {
    $('.crafting-menu').empty();
    savedRecipes = recipes;
    savedRecipes.forEach(recipe => {
        let ingredientsHtml = '';
        
        recipe.ingredients.forEach(ingredient => {
            // Add hidden-item class if ingredient.hidden is true
            const hiddenClass = ingredient.hidden ? 'hidden-item' : '';
            
            // Encrypt name if hidden
            const displayName = ingredient.hidden ? encryptName(ingredient.label) : ingredient.label;
            
            // Modify count display for hidden items
            const countDisplay = ingredient.hidden 
                ? `?/${ingredient.required}` 
                : `${ingredient.current}/${ingredient.required}`;
            
            // Generate question mark overlay for hidden items
            const hiddenOverlay = ingredient.hidden 
                ? '<div class="hidden-overlay">?</div>' 
                : '';
            
            // For hidden items, use a generic placeholder instead of the actual image
            const imgSrc = ingredient.hidden 
                ? '/api/placeholder/50/50'  // Generic placeholder for hidden items
                : ingredient.icon;          // Actual image for visible items
            
            ingredientsHtml += `
                <div class="ingredient ${hiddenClass}" data-name="${ingredient.name}">
                    <img src="${imgSrc}" alt="Item">
                    ${hiddenOverlay}
                    <div class="ingredient-count ${ingredient.status}">${countDisplay}</div>
                    <div class="ingredient-name">${displayName}</div>
                </div>
            `;
        });
        
        // Generate outputs HTML
        let outputsHtml = '';
        const hasMultipleOutputs = recipe.outputs && recipe.outputs.length > 1;
        
        // If there are outputs defined, use them, otherwise use the recipe name/icon as default output
        const outputs = recipe.outputs || [{ name: recipe.name, quantity: 1, icon: recipe.icon }];
        
        outputs.forEach(output => {
            outputsHtml += `
                <div class="output-item">
                    <div class="output-icon">
                        <img src="${output.icon}" alt="${output.name}">
                        ${output.quantity > 1 ? `<div class="output-quantity">x${output.quantity}</div>` : ''}
                    </div>
                    <div class="output-name">${output.name}</div>
                </div>
            `;
        });
        
        const buttonClass = recipe.canCraft ? 'craft-button' : 'craft-button disabled';
        const buttonText = recipe.canCraft ? 'Craft item' : 'Not craftable';  // Shortened text
        
        const recipeHtml = `
            <div class="recipe" id="${recipe.id}">
                <div class="recipe-header">
                    
                    <div class="recipe-name">${recipe.name}</div>
                </div>
                <div class="recipe-content">
                    <div class="recipe-io-container">
                        <div class="ingredients-container">
                            <div class="section-label">Required Items</div>
                            <div class="ingredients">
                                ${ingredientsHtml}
                            </div>
                        </div>
                        <div class="outputs-container">
                            <div class="section-label">Output Items</div>
                            <div class="outputs ${hasMultipleOutputs ? 'multiple' : ''}">
                                ${outputsHtml}
                            </div>
                        </div>
                    </div>
                    <div class="craft-container">
                        <div class="craft-controls">
                            <button class="${buttonClass}" data-recipe-id="${recipe.id}">${buttonText}</button>
                            <div class="quantity-wrapper">
                                <div class="quantity-label">Quantity</div>
                                <div class="quantity-control">
                                    <button class="quantity-btn minus" data-recipe-id="${recipe.id}">-</button>
                                    <input type="number" min="1" value="1" class="quantity-input" data-recipe-id="${recipe.id}">
                                    <button class="quantity-btn plus" data-recipe-id="${recipe.id}">+</button>
                                </div>
                            </div>
                        </div>
                        <div class="timer" id="timer-${recipe.id}">
                            <i class="far fa-clock"></i> ${recipe.craftTime} sec
                        </div>
                    </div>
                </div>
            </div>
        `;
        $('.crafting-menu').append(recipeHtml);
    });
}

// Helper function to encrypt item names
function encryptName(name) {
    // Replace with random characters or question marks based on name length
    let encrypted = '';
    for (let i = 0; i < name.length; i++) {
        // Use mix of question marks and random characters for more mystery
        encrypted += (Math.random() > 0.5) ? '?' : '*';
    }
    return encrypted;
}

// Function to update ingredients based on craft quantity
function updateIngredientsForQuantity(recipeId, quantity) {
    const recipe = savedRecipes.find(r => r.id === recipeId);
    if (!recipe) return;
    
    let canCraftWithQuantity = true;
    
    recipe.ingredients.forEach(ingredient => {
        if (ingredient.remove) {
            const totalRequired = ingredient.required * quantity;
            const $ingredient = $(`#${recipeId} .ingredient[data-name="${ingredient.name}"]`);
            const $count = $ingredient.find('.ingredient-count');
            
            // Only update visible ingredients display (not hidden ones)
            if (!ingredient.hidden) {
                $count.text(`${ingredient.current}/${totalRequired}`);
                
                // Update status based on new quantity
                $count.removeClass('complete partial missing');
                
                if (ingredient.current >= totalRequired) {
                    $count.addClass('complete');
                } else if (ingredient.current > 0) {
                    $count.addClass('partial');
                    canCraftWithQuantity = false;
                } else {
                    $count.addClass('missing');
                    canCraftWithQuantity = false;
                }
            } else {
                // For hidden ingredients, just check if we have enough
                if (ingredient.current < totalRequired) {
                    canCraftWithQuantity = false;
                }
            }
        }
    });

    // Update the time based on quantity if longer then 60 seconds (1 minute) change to minutes and seconds
    const $timer = $(`#timer-${recipeId}`);
    if (recipe.craftTime * quantity >= 60) {
        const minutes = Math.floor((recipe.craftTime * quantity) / 60);
        const seconds = (recipe.craftTime * quantity) % 60;
        $timer.html(`<i class="far fa-clock"></i> ${minutes} min ${seconds} sec`);
    }
    else {
        $timer.html(`<i class="far fa-clock"></i> ${recipe.craftTime * quantity} sec`);
    }
    
    // Update craft button status
    const $button = $(`.craft-button[data-recipe-id="${recipeId}"]`);
    
    if (canCraftWithQuantity) {
        $button.removeClass('disabled').text('Craft item');
    } else {
        $button.addClass('disabled').text('Lack of items for craft');
    }
}

// Function to simulate crafting
// Function to simulate crafting
function startCrafting(recipeId, quantity = 1) {
    const recipe = savedRecipes.find(r => r.id === recipeId);
    if (!recipe) {
        console.error(`Recipe with ID ${recipeId} not found`);
        return
    };
    
    // Check if we can craft with the desired quantity
    let canCraftWithQuantity = true;
    recipe.ingredients.forEach(ingredient => {
        // Check if the ingredient is sufficient for the desired quantity
        if (!ingredient.remove) {
            if (ingredient.current < ingredient.required) {
                canCraftWithQuantity = false;
            }
        }else {
            const totalRequired = ingredient.required * quantity;
            if (ingredient.current < totalRequired) {
                canCraftWithQuantity = false;
            }
        }
    });
    
    if (!canCraftWithQuantity) {
        return; // Not enough materials for the desired quantity
    }

    $('.craft-button').addClass('disabled');
    $('.quantity-input').prop('disabled', true);
    $('.quantity-btn').prop('disabled', true);

    if (recipe.skillCheck && recipe.skillCheck.enabled) {
        // Start the skill check mini-game
        $('.crafting-menu').hide();
        initSkillGame(recipeId, quantity, recipe.skillCheck);
        return;
    }
    
    const $button = $(`.craft-button[data-recipe-id="${recipeId}"]`);
    const $timer = $(`#timer-${recipeId}`);
    let timeLeft = recipe.craftTime * quantity; // Scale time based on quantity
    const totalTime = timeLeft;
    const timePerItem = recipe.craftTime;
    
    // Style timer div with progress border
    $timer.css({
        'position': 'relative',
        'border': '2px solid transparent',
        'background-clip': 'padding-box',
        'border-radius': '5px',
        'padding': '8px',
        'overflow': 'hidden'
    });
    
    // Create timer border container
    if ($timer.find('.timer-border-container').length === 0) {
        $timer.append('<div class="timer-border-container"></div>');
    }
    
    // Create timer progress elements with smoother animations
    const $borderContainer = $timer.find('.timer-border-container');
    $borderContainer.html(`
        <div class="timer-border top"></div>
        <div class="timer-border right"></div>
        <div class="timer-border bottom"></div>
        <div class="timer-border left"></div>
    `);
    
    // Style the timer borders with improved transitions
    $timer.find('.timer-border-container').css({
        'position': 'absolute',
        'top': '0',
        'left': '0',
        'width': '100%',
        'height': '100%',
        'pointer-events': 'none'
    });
    
    $timer.find('.timer-border').css({
        'position': 'absolute',
        'background-color': '#8bc34a',
        'transition': 'transform 0.3s cubic-bezier(0.4, 0.0, 0.2, 1)' // Smoother easing
    });
    
    $timer.find('.timer-border.top').css({
        'top': '0',
        'left': '0',
        'width': '100%',
        'height': '2px',
        'transform': 'scaleX(0)',
        'transform-origin': 'left'
    });
    
    $timer.find('.timer-border.right').css({
        'top': '0',
        'right': '0',
        'width': '2px',
        'height': '100%',
        'transform': 'scaleY(0)',
        'transform-origin': 'top'
    });
    
    $timer.find('.timer-border.bottom').css({
        'bottom': '0',
        'left': '0',
        'width': '100%',
        'height': '2px',
        'transform': 'scaleX(0)',
        'transform-origin': 'right'
    });
    
    $timer.find('.timer-border.left').css({
        'top': '0',
        'left': '0',
        'width': '2px',
        'height': '100%',
        'transform': 'scaleY(0)',
        'transform-origin': 'bottom'
    });
    

    // Handle button text
    if (quantity > 1) {
        $button.text(`Crafting ${quantity}...`);
    } else {
        $button.text('Crafting...');
    }
    
    var givenItem = 0;
    var nextItemAt = totalTime - timePerItem;
    
    const animationInterval = 200; // Update 10 times per second instead of once per second
    const countdownInterval = 1000; // Keep countdown at 1 second
    let animationCounter = 0;
    
    const countdown = setInterval(() => {
        timeLeft--;
        
        // Update timer text
        if (timeLeft >= 60) {
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            $timer.html(`<i class="far fa-clock"></i> ${minutes} min ${seconds < 10 ? '0' : ''}${seconds} sec`);
        } else {
            $timer.html(`<i class="far fa-clock"></i> ${timeLeft} sec`);
        }
        
        // Re-append the border container since the HTML was updated
        if ($timer.find('.timer-border-container').length === 0) {
            $timer.append($borderContainer);
        }
        
        // Check if it's time to give an item
        if (timeLeft === nextItemAt) {
            givenItem++;
            
            // Reset the border animation for the next item with a smoother transition
            $timer.find('.timer-border').css('transition', 'transform 0.5s cubic-bezier(0.4, 0.0, 0.2, 1)');
            
            setTimeout(() => {
                $timer.find('.timer-border.top').css('transform', 'scaleX(0)');
                $timer.find('.timer-border.right').css('transform', 'scaleY(0)');
                $timer.find('.timer-border.bottom').css('transform', 'scaleX(0)');
                $timer.find('.timer-border.left').css('transform', 'scaleY(0)');
                
                // Restore the original transition after reset
                setTimeout(() => {
                    $timer.find('.timer-border').css('transition', 'transform 0.3s cubic-bezier(0.4, 0.0, 0.2, 1)');
                }, 500);
            }, 100);
            
            // Calculate the next threshold
            nextItemAt = totalTime - (timePerItem * (givenItem + 1));
            
            // Make NUI callback to give the item
            fetch(`https://${resourceName}/craftItem`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ recipeId: recipeId})
            })
            .then(response => response.json())
            .then(data => {
                if (!data) {
                    // Close the UI if the callback indicates failure
                    $('body').fadeOut(300, function() { // Smoother fadeout
                        // Send message back to Lua to reset NUI focus
                        fetch('https://it-crafting/closeMenu', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify({})
                        });
                    });
                    clearInterval(countdown);
                    clearInterval(animationTimer);
                    $('.crafting-menu').hide();
                    $('body').show();
                    return;
                }
            })
            .catch(error => {
                console.error('Error during craftItem callback:', error);
                // Close the UI in case of an error
                $('body').fadeOut(300, function() { // Smoother fadeout
                    // Send message back to Lua to reset NUI focus
                    fetch('https://it-crafting/closeMenu', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({})
                    });
                });
                clearInterval(countdown);
                clearInterval(animationTimer);
                $('.crafting-menu').hide();
                $('body').show();
                return;
            });
        }
        
        // Update button progress bar
        const totalProgressPercentage = ((totalTime - timeLeft) / totalTime) * 100;
        $button.find('.progress-overlay').css('width', `${totalProgressPercentage}%`);
        
        if (timeLeft <= 0) {
            // Wait for a second before changing the menu back
            setTimeout(() => {
                clearInterval(countdown);
                clearInterval(animationTimer);
                
                // Smooth fade-out for the timer border
                $timer.find('.timer-border').css({
                    'transition': 'opacity 0.5s ease, transform 0.5s ease',
                    'opacity': '0'
                });
                
                setTimeout(() => {
                    // Remove the timer border
                    $timer.find('.timer-border-container').remove();
                    $timer.css({
                        'border': 'none',
                        'position': '',
                        'background-clip': '',
                        'padding': ''
                    });
                    
                    $(`#timer-${recipeId}`).html(`<i class="far fa-clock"></i> ${recipe.craftTime} sec`);
                    $button.text('Craft item');
                    
                    $('.craft-button').removeClass('disabled');
                    $('.quantity-input').prop('disabled', false);
                    $('.quantity-btn').prop('disabled', false);
                    
                    // Reset quantity input to 1
                    $(`input.quantity-input[data-recipe-id="${recipeId}"]`).val(1);

                    // Refetch the item count for all ingredients in the recipe
                    Promise.all(
                        recipe.ingredients.map(ingredient => {
                            return fetchItemCount(ingredient.name).then(newCount => {
                                ingredient.current = newCount; // Update the ingredient's current count
                            });
                        })
                    ).then(() => {
                        // Re-render to update ingredients after fetching new counts
                        renderRecipes(savedRecipes);
                    });
                }, 500);
            }, 500);
        }
    }, countdownInterval);
    
    // Create a separate interval for smoother animation updates
    const animationTimer = setInterval(() => {
        // Only update if countdown is still running
        if (timeLeft <= 0) return;
        
        animationCounter += animationInterval;
        if (animationCounter >= 1000) {
            animationCounter = animationCounter % 1000;
        }
        
        // Calculate fractional seconds for smoother animation
        const fractionTimeLeft = timeLeft - (animationCounter / 1000);
        
        // Calculate progress for current item with smoother animation
        const currentItemProgress = (nextItemAt + timePerItem - fractionTimeLeft) / timePerItem;
        const clampedProgress = Math.min(Math.max(currentItemProgress, 0), 1);
        
        // Animate the borders with smoother transitions
        // For the first 25% fill the top border
        if (clampedProgress <= 0.25) {
            const topProgress = clampedProgress * 4;
            $timer.find('.timer-border.top').css('transform', `scaleX(${topProgress})`);
        } 
        // For 25-50% fill the right border
        else if (clampedProgress <= 0.5) {
            const rightProgress = (clampedProgress - 0.25) * 4;
            $timer.find('.timer-border.top').css('transform', 'scaleX(1)');
            $timer.find('.timer-border.right').css('transform', `scaleY(${rightProgress})`);
        } 
        // For 50-75% fill the bottom border (right to left)
        else if (clampedProgress <= 0.75) {
            const bottomProgress = (clampedProgress - 0.5) * 4;
            $timer.find('.timer-border.top').css('transform', 'scaleX(1)');
            $timer.find('.timer-border.right').css('transform', 'scaleY(1)');
            $timer.find('.timer-border.bottom').css('transform', `scaleX(${bottomProgress})`);
        } 
        // For 75-100% fill the left border (bottom to top)
        else {
            const leftProgress = (clampedProgress - 0.75) * 4;
            $timer.find('.timer-border.top').css('transform', 'scaleX(1)');
            $timer.find('.timer-border.right').css('transform', 'scaleY(1)');
            $timer.find('.timer-border.bottom').css('transform', 'scaleX(1)');
            $timer.find('.timer-border.left').css('transform', `scaleY(${leftProgress})`);
        }
        
        // Update button progress with smoother animation
        const totalProgressPercentage = ((totalTime - fractionTimeLeft) / totalTime) * 100;
        $button.find('.progress-overlay').css('width', `${totalProgressPercentage}%`);
    }, animationInterval);
    
    // Clean up event listeners when done
    $(window).on('keydown', function(event) {
        if (event.key === 'Escape') {
            clearInterval(countdown);
            clearInterval(animationTimer);
            return;
        }
    });
}

// Function to fetch item count from the lua code
function fetchItemCount(name) {
    // Make a callback to the Lua code to fetch the new item count
    return fetch(`https://${resourceName}/fetchItemCount`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ name: name })
    })
    .then(response => response.json())
    .then(data => {
        return data; // Ensure the Lua callback returns the correct count
    })
    .catch(error => {
        console.error('Error fetching item count:', error);
        return 0; // Default to 0 if there's an error
    });
}