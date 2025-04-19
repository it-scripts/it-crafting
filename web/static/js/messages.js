$(document).ready(function() {

    $(window).on('message', function(event) {
        const data = event.originalEvent.data;
        if (data.action === 'showCraftingUi') {
            if (!data.recipes || data.recipes.length === 0) {
                $('.crafting-menu').html(`
                    <div class="loading-spinner">
                        <div class="spinner"></div>
                        <div>Loading Recipes...</div>
                    </div>
                `);
                
                // Zeige das UI
                $('.crafting-menu').show();

                fetch('https://it-crafting/uiReady', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({})
                });
            }else {
                renderRecipes(data.recipes);
                $('#loading').hide();
            }
        }
    });

    $(window).on('keydown', function(event) {
        if (event.key === 'Escape') {
            $('body').fadeOut(100, function() {
                // Send message back to Lua to reset NUI focus
                fetch('https://it-crafting/closeMenu', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({})
                });
                resetGame();
                $('.crafting-menu').hide();
                $('.game-container').hide();
                $('body').show();
            });
        }
    });

    $('body').on('click', '.craft-button:not(.disabled)', function() {
        const recipeId = $(this).data('recipe-id');
        const quantity = parseInt($(`input.quantity-input[data-recipe-id="${recipeId}"]`).val(), 10) || 1;
        startCrafting(recipeId, quantity);
    });
    
    // Add event listeners for quantity controls
    $('body').on('click', '.quantity-btn.minus', function() {
        const recipeId = $(this).data('recipe-id');
        const $input = $(`input.quantity-input[data-recipe-id="${recipeId}"]`);
        let value = parseInt($input.val(), 10) || 1;
        if (value > 1) {
            $input.val(value - 1).trigger('change');
        }
    });
    
    $('body').on('click', '.quantity-btn.plus', function() {
        const recipeId = $(this).data('recipe-id');
        const $input = $(`input.quantity-input[data-recipe-id="${recipeId}"]`);
        let value = parseInt($input.val(), 10) || 1;
        $input.val(value + 1).trigger('change');
    });
    
    $('body').on('change', '.quantity-input', function() {
        const recipeId = $(this).data('recipe-id');
        const quantity = parseInt($(this).val(), 10) || 1;
        
        // Ensure minimum value of 1
        if (quantity < 1) {
            $(this).val(1);
        }
        
        // Update ingredient requirements based on quantity
        updateIngredientsForQuantity(recipeId, quantity);
    });

    // Add this to the event listeners section for more control
    $('.quantity-input').on('keydown', function(e) {
        // Only allow number keys, backspace, delete, tab, escape, enter
        if (
            !(
                e.keyCode === 8 || // Backspace
                e.keyCode === 9 || // Tab
                e.keyCode === 13 || // Enter
                e.keyCode === 27 || // Escape
                e.keyCode === 46 || // Delete
                (e.keyCode >= 48 && e.keyCode <= 57) || // Numbers
                (e.keyCode >= 96 && e.keyCode <= 105) // Numpad
            )
        ) {
            e.preventDefault();
        }
    });
});