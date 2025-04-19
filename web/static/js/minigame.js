const resourceName = 'it-crafting';

// DOM-Elemente
let circlesContainer = document.querySelector('.circles-container');
let roundsContainer;
let gameStatus = document.querySelector('.game-status');
let progressFill = document.querySelector('.progress-fill');

// Spielvariablen
let circles = [];
let currentRound = 1;
let roundResults = [];
let score = 0;
let currentSequence = [];
let playerSequence = [];
let isMemorizing = true;
let timer = null;
let numberTimer = null;
let progressTimer = null;

// Current difficulty configuration
let diffCircleCount = 5;
let diffMemorizeTime = 3000;
let diffPlayTime = 10000;
let diffMaxRounds = 100;

// Current Recipe Settings
let currentRecipeId = 0;
let currentQuantity = 0;

let config = {
    'easy': { circleCount: 5, memorizeTime: 2000, playTime: 5000 },
    'medium': { circleCount: 7, memorizeTime: 3000, playTime: 7000 },
    'hard': { circleCount: 9, memorizeTime: 4000, playTime: 10000 }
};

// Initialize skill game
function initSkillGame(recipeId, quantity, skillCheck) {
    // Store current recipe info
    currentRecipeId = recipeId;
    currentQuantity = quantity;

    // Configure difficulty based on skillCheck
    if (skillCheck.difficulty) {
        // Get first element of the array
        let difficulty = skillCheck.difficulty[0].toLowerCase();
        diffCircleCount = config[difficulty].circleCount;
        diffMemorizeTime = config[difficulty].memorizeTime;
        diffPlayTime = config[difficulty].playTime;
    } else if (skillCheck.settings) {
        diffCircleCount = skillCheck.settings.circleCount;
        diffMemorizeTime = skillCheck.settings.memorizeTime;
        diffPlayTime = skillCheck.settings.playTime;
        diffMaxRounds = skillCheck.settings.maxRounds;
    } else {
        diffCircleCount = 5;
        diffMemorizeTime = 3000;
        diffPlayTime = 10000;
        diffMaxRounds = 100;
    }

    diffMaxRounds = quantity;

    // Show game container
    $('.game-container').show();

    // Setup round indicators
    setupRoundIndicators();

    // Start first round
    startRound();
}

// Setup round indicators
function setupRoundIndicators() {
    $('.rounds-container').empty();
    for (let i = 0; i < diffMaxRounds; i++) {
        const indicator = $('<div class="round-indicator"></div>');
        if (i === 0) indicator.addClass('current');
        $('.rounds-container').append(indicator);
    }
}

// Start new round
function startRound() {
    isMemorizing = true;
    playerSequence = [];
    
    // Reset UI
    $('.circles-container').empty();
    $('.game-status').text('Memorize the sequence!');
    
    // Generate random circles
    generateCircles();
    
    // Timer for hiding numbers - separate timer
    clearTimeout(numberTimer);
    numberTimer = setTimeout(() => {
        hideNumbers();
        $('.game-status').text('Tap the circles in the correct order!');
    }, diffMemorizeTime);
    
    // Start play timer immediately
    startPlayTimer();
    
    // Allow player to start clicking immediately
    isMemorizing = false;
}

// Generate circles
function generateCircles() {
    circles = [];
    currentSequence = [];
    
    const circleCount = diffCircleCount;
    
    // Create circles
    for (let i = 1; i <= circleCount; i++) {
        const circle = $('<div class="circle"></div>');
        circle.text(i);
        circle.attr('data-index', i);
        
        // Calculate random position within container
        const containerWidth = $('.circles-container').width();
        const containerHeight = $('.circles-container').height();
        const circleSize = 60;
        
        // Calculate available space with margins
        const maxX = containerWidth - circleSize - 10;
        const maxY = containerHeight - circleSize - 10;
        
        // Try to find a non-overlapping position
        let validPosition = false;
        let attempts = 0;
        let posX, posY;
        
        while (!validPosition && attempts < 100) {
            posX = Math.floor(Math.random() * maxX) + 5;
            posY = Math.floor(Math.random() * maxY) + 5;
            
            validPosition = true;
            
            // Check for overlap with existing circles
            for (let j = 0; j < circles.length; j++) {
                const existingCircle = circles[j];
                const existingX = parseInt(existingCircle.css('left'));
                const existingY = parseInt(existingCircle.css('top'));
                
                // Calculate distance between circle centers
                const distance = Math.sqrt(
                    Math.pow(posX + circleSize/2 - (existingX + circleSize/2), 2) + 
                    Math.pow(posY + circleSize/2 - (existingY + circleSize/2), 2)
                );
                
                // If overlapping, recalculate position
                if (distance < circleSize) {
                    validPosition = false;
                    break;
                }
            }
            
            attempts++;
        }
        
        circle.css({
            'left': posX + 'px',
            'top': posY + 'px'
        });
        
        // Event listener
        circle.on('click', function() {
            if (!isMemorizing) {
                handleCircleClick($(this));
            }
        });
        
        $('.circles-container').append(circle);
        circles.push(circle);
        currentSequence.push(i);
    }
}

// Hide numbers
function hideNumbers() {
    circles.forEach(circle => {
        circle.text('');
    });
}

// Start play timer
function startPlayTimer() {
    // Reset progress bar
    $('.progress-fill').css({
        'width': '100%',
        'transition': 'none'
    });
    
    // Force reflow to ensure style reset
    $('.progress-fill')[0].offsetWidth;
    
    // Set and start transition animation
    $('.progress-fill').css({
        'transition': `width ${diffPlayTime}ms linear`,
        'width': '0%'
    });
    
    // Timer for round end
    clearTimeout(timer);
    timer = setTimeout(() => {
        // When time runs out, end round as a loss
        endRound(false, true);
    }, diffPlayTime);
}

// Handle circle click
function handleCircleClick(circle) {
    // Ignore if circle already clicked
    if (circle.hasClass('correct') || circle.hasClass('incorrect')) {
        return;
    }
    
    const clickedIndex = parseInt(circle.attr('data-index'));
    
    // Determine next expected index in the sequence
    const expectedIndex = currentSequence[playerSequence.length];
    
    if (clickedIndex === expectedIndex) {
        // Correct circle clicked
        circle.addClass('correct');
        playerSequence.push(clickedIndex);
        
        // Check if sequence is complete
        if (playerSequence.length === currentSequence.length) {
            clearTimeout(timer);
            endRound(true);
        }
    } else {
        // Wrong circle clicked
        circle.addClass('incorrect');
        clearTimeout(timer);
        
        // Immediately move to next round
        endRound(false, true);
    }
}

// End round
function endRound(isWin, immediateNextRound = false) {
    // Stop timers
    clearTimeout(timer);
    clearTimeout(numberTimer);
    
    // Stop progress bar animation
    $('.progress-fill').css('transition', 'none');
    
    // Save round result
    roundResults[currentRound - 1] = isWin;
    
    // Update round indicator
    const indicators = $('.round-indicator');
    indicators.eq(currentRound - 1).removeClass('current');
    
    if (isWin) {
        indicators.eq(currentRound - 1).addClass('win');
        $('.game-status').text('Success!');
        // Call win function
        onRoundWin();
    } else {
        indicators.eq(currentRound - 1).addClass('lose');
        $('.game-status').text('Failed!');
        
        // Immediately hide all circles on wrong click
        if (immediateNextRound) {
            $('.circles-container').empty();
        }
    }
    
    // Check if game is over
    if (currentRound < diffMaxRounds) {
        currentRound++;
        if (currentRound <= diffMaxRounds) {
            indicators.eq(currentRound - 1).addClass('current');
        }
        
        // Start next round after delay
        // Immediate next round on wrong click
        const delay = immediateNextRound ? 500 : 2000;
        setTimeout(() => {
            startRound();
        }, delay);
    } else {
        // Game is over
        $('.craft-button').removeClass('disabled');
        $('.quantity-input').prop('disabled', false);
        $('.quantity-btn').prop('disabled', false);
        $('.game-container').hide();
        $('.crafting-menu').show();
        resetGame();
        Promise.all(
            savedRecipes.map(recipe => {
                return Promise.all(
                    recipe.ingredients.map(ingredient => {
                        return fetchItemCount(ingredient.name).then(newCount => {
                            ingredient.current = newCount; // Update the ingredient's current count
                        });
                    })
                );
            })
        ).then(() => {
            // Re-render to update ingredients after fetching new counts
            renderRecipes(savedRecipes);
        });
    }
}

// Win function - called on each round win
function onRoundWin() {
    $.post(`https://${resourceName}/craftItem`, JSON.stringify({ recipeId: currentRecipeId }))
        .done(function(data) {
            if (!data) {
                // Close UI if callback indicates failure
                $('body').fadeOut(300, function() {
                    // Send message back to FiveM to reset NUI focus
                    $.post(`https://${resourceName}/closeMenu`, JSON.stringify({}));
                });
                $('.crafting-menu').hide();
                $('.game-container').hide();
                clearTimeout(timer);
                clearTimeout(numberTimer);
                $('body').show();
            }
        })
        .fail(function(error) {
            console.error('Error during craftItem callback:', error);
            // Close UI in case of error
            $('body').fadeOut(300, function() {
                // Send message back to FiveM to reset NUI focus
                $.post(`https://${resourceName}/closeMenu`, JSON.stringify({}));
            });
            $('.crafting-menu').hide();
            $('.game-container').hide();
            clearTimeout(timer);
            clearTimeout(numberTimer);
            $('body').show();
        }
    );
}

// Reset game
function resetGame() {
    clearTimeout(timer);
    clearTimeout(numberTimer);
    
    $('.progress-fill').css({
        'transition': 'none',
        'width': '100%'
    });
    
    currentRound = 1;
    roundResults = [];
    score = 0;
}

// If in a browser with window, we can add these event listeners for testing
if (typeof window !== 'undefined') {
    // Fixed missing element references that were in the original code
    $(document).ready(function() {
        // Fix for missing roundsContainer variable in original code
        roundsContainer = $('.rounds-container')[0];
        
        // Use jQuery to bind events if needed
        // For example, a restart button might need to be bound
    });
}