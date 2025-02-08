function blackjack_game()

  [y,fs]=audioread('draw.wav');

  function helpScreen()
     game.help = figure ('Name', 'INSTRUCTIONS', 'Position',[1000,100,400,400], ...
  'Numbertitle', 'off','Menubar','none','Resize','off','Color',[0,0.4,0]);

   uicontrol('style','text', 'String', 'INSTRUCTIONS', 'position', [0,150,400,400],'fontsize',20, ...
  'ForegroundColor','w','BackgroundColor',[0,0.4,0], 'FontWeight', 'bold');
  uicontrol('style','text', 'String', "In order to start the game please press 'PLAY GAME' \n button, and then 'HIT!' button for your first draw.", 'position', [-50,250,500,40],'fontsize',10, ...
  'ForegroundColor','w','BackgroundColor',[0,0.4,0],'ForegroundColor',[0.8,0.5,0]);
  uicontrol('style','text', 'String', "You play for bonus points on your final grade, \n however if you lose, professor will reduce 10% \n from your final grade.", 'position', [-50,150,500,100],'fontsize',10, ...
  'ForegroundColor','w','BackgroundColor',[0,0.4,0]);
   uicontrol('style','text', 'String', "Card displaying on your screen is your last drawn card, \n all card values are written on the left.", 'position', [-50,100,500,40],'fontsize',10, ...
  'ForegroundColor','w','BackgroundColor',[0,0.4,0]);


endfunction


helpScreen();

  game.playerWins = 0;
  game.dealerWins = 0;
  reset();


  c1=imread('A.png');
  c2=imread('2.png');
  c3=imread('3.png');
  c4=imread('4.png');
  c5=imread('5.png');
  c6=imread('6.png');
  c7=imread('7.png');
  c8=imread('8.png');
  c9=imread('9.png');
  c10=imread('10.png');
  deck=imread('deck.png');
  bgimg = imread('cardsshow.png');
  dealerimage = imread('namas.png');
  headerimg = imread('header.png');
  ax = axes('Units', 'pixels', 'Position', [250,550,500,80]);
  ax2 = axes('Units', 'pixels', 'Position', [180,550,500,80]);
  ax3 = axes('Units', 'pixels', 'Position', [250,250,500,80]);
  ax4 = axes('Units', 'pixels', 'Position', [180,250,500,80]);
  bg = axes('Units', 'pixels', 'Position', [0,-200,500,300]);
  dealerax = axes('Units', 'pixels', 'Position', [220,95,500,150]);
  headerax = axes('Units', 'pixels', 'Position', [175,650,450,200]);
  set(ax, 'Visible', 'off');
  set(ax2, 'Visible', 'off');
  set(ax3, 'Visible', 'off');
  set(ax4, 'Visible', 'off');

  imshow(bgimg, 'Parent', bg);
  imshow(dealerimage, 'Parent', dealerax);
  imshow(headerimg, 'Parent', headerax);


  %deck shuffle system
  function deck = shuffle()
    % Define card ranks
    ranks = [2:10, 10, 10, 10, 11]; % Card values: 2-10, J, Q, K, A
    suits = [1:4]; % Represent four suits (this is optional for uniqueness)

    % Create a full deck (ranks only, ignoring suits for simplicity)
    deck = repmat(ranks, 1, numel(suits)); % 4 sets of card ranks
    deck = deck(randperm(length(deck)));  % Shuffle the deck
endfunction


  function reset()
        % Reset game-specific variables
        game.deck = shuffle();
        game.playerCards = game.deck(1:1);
        game.dealerCards = game.deck(2:2);
        game.deck = game.deck(3:end);
        game.playerScoreCount = calculateScore(game.playerCards);
        game.dealerScoreCount = calculateScore(game.dealerCards);
        game.playerTurn = true;
        game.result = '';
        game.result1 = "Prof:\n Welcome and good luck :)";


        % Create or update GUI
        if ~isfield(game, 'app') || ~isvalid(game.app)
            createScreen();
        else
            updateScreen();
        end

endfunction

%these two showButtons() functions trigger player, dealer and buttons visibility

  function showButtons()

        sound(y, fs);

        playerHit();

        set(game.hitButton, 'Visible', 'on');
        set(game.playagainButton, 'Visible', 'off');
        set(game.stayButton, 'Visible', 'off');

        reset();

  endfunction

  function showButtons1()

        set(game.hitButton, 'Visible', 'on');

        playerHit();

        set(game.hitButton, 'Visible', 'on');
        set(game.stayButton, 'Visible', 'on');
        set(game.playerBox,'Visible', 'on');
        set(game.dealerBox,'Visible', 'on');
        set(game.playerCurrent, 'Visible', 'on');
        set(game.dealerCurrent, 'Visible', 'off');

  endfunction

  function createScreen()

  game.app = figure('Name', 'BLACKJACK GAME by Vedad Halilovic', 'Position', [100,100,800,800], ...
  'Numbertitle', 'off','Menubar','none','Resize', 'off','Color',[0,0.4,0]);

  %header text
  uicontrol('style','text', 'String', 'Made by: Vedad Halilovic', 'position', [150,665,500,40],'fontsize',12, ...
  'ForegroundColor','w','BackgroundColor',[0,0.4,0])
  uicontrol('style','text', 'String', '*This project is made for educational purposes only. ENS101 class project*', 'position', [150,650,500,25],'fontsize',10, ...
  'ForegroundColor',[0.6,0.6,0.6],'BackgroundColor',[0,0.4,0])
  uicontrol('style','text', 'String', 'Score:', 'position', [550,590,50,50],'fontsize',10, ...
  'ForegroundColor','w','BackgroundColor',[0,0.4,0])
  uicontrol('style','text', 'String', 'Score:', 'position', [550,290,50,50],'fontsize',10, ...
  'ForegroundColor','w','BackgroundColor',[0,0.4,0])

  %player box
  game.playerBox = uicontrol('style', 'text', 'position', [150,550,250,50],'fontsize',12, ...
  'ForegroundColor','w','String','','Visible','off','BackgroundColor',[0,0.4,0])
  game.playerCards = uicontrol('style', 'text', 'string', '', 'position', [150,400,250,150],'fontsize',12, ...
  'ForegroundColor','w','BackgroundColor',[0,0.4,0])
  game.playerScore = uicontrol('style', 'text','String', 'Player score: ', 'position', [150,450,100,50],'fontsize',10, ...
  'ForegroundColor','w','BackgroundColor',[0,0.4,0],'HorizontalAlignment','left','FontWeight','bold')
  game.playerCurrent = uicontrol('style', 'text', 'position', [550,550,50,50],'fontsize',20, ...
  'ForegroundColor','w','String','','Visible','off','BackgroundColor',[0,0.6,0], 'FontWeight', 'bold');

  %buttons implementation
  game.hitButton = uicontrol('style', 'pushbutton', 'string', 'HIT!', 'position', [150,350,150,50],'fontsize',12, ...
  'ForegroundColor', 'w', 'BackgroundColor','k','FontWeight','bold','Visible','off','Callback',@(src, event) showButtons1())

  game.stayButton = uicontrol('style', 'pushbutton', 'string', 'STAND!', 'position', [500,350,150,50],'fontsize',12, ...
  'ForegroundColor', 'w', 'BackgroundColor','k','FontWeight','bold','Visible','off','Callback',@(src, event) playerStand())
  game.playagainButton = uicontrol('style', 'pushbutton', 'string', 'PLAY GAME', 'position', [550,25,150,50],'fontsize',12, ...
  'ForegroundColor', 'w', 'BackgroundColor','k','FontWeight','bold','Callback', @(src, event) showButtons())

  %Dealer box
  game.dealerBox = uicontrol('style', 'text', 'position', [150,250,250,50],'fontsize',12, ...
  'ForegroundColor','w','String','','Visible','off','BackgroundColor',[0,0.4,0])
  game.dealerCards = uicontrol('style', 'text', 'string', '', 'position', [150,100,250,150],'fontsize',12, ...
  'ForegroundColor','w','BackgroundColor',[0,0.4,0])
  game.dealerScore = uicontrol('style', 'text','String', 'Dealer score: ', 'position', [150,100,100,30],'fontsize',10, ...
  'ForegroundColor','w','BackgroundColor',[0,0.4,0],'HorizontalAlignment','left','FontWeight','bold')
  game.dealerCurrent = uicontrol('style', 'text', 'position', [550,250,50,50],'fontsize',20, ...
  'ForegroundColor','w','String','','Visible','off','BackgroundColor',[0,0.6,0], 'FontWeight', 'bold');

  %Next turn message box
  game.message = uicontrol('Style', 'text', 'String', '', ...
    'Position', [300, 400, 200, 50], 'FontSize', 10, ...
    'ForegroundColor', 'w', 'BackgroundColor', [0, 0.4, 0]);

  %text to show who won the game
  game.winlose = uicontrol('Style', 'text', 'Position', [150, 425, 500, 40], ...
            'String', '', 'FontSize', 12, 'HorizontalAlignment', 'center', 'BackgroundColor',[0,0.4,0], ...
            'ForegroundColor', 'w','FontWeight','bold');

  game.winlose1 = uicontrol('Style', 'text', 'Position', [530,150,200,50], ...
            'String', '', 'FontSize', 12, 'BackgroundColor',[0,0.4,0], ...
            'ForegroundColor', 'w','FontWeight','bold','ForegroundColor',[0.8,0.8,0]);


  updateScreen();

  endfunction

  function updateScreen()

   % Update dealer display (hide one card if it's the player's turn)
        if game.playerTurn == true
            set(game.dealerBox, 'String', sprintf("Dealer's cards: %s, [?]", ...
                display_card1(game.dealerCards(1))));

        else
            set(game.dealerBox, 'String', sprintf("Dealer's cards:\n %s", ...
                display_cards(game.dealerCards)));
            set(game.dealerCurrent, 'String', sprintf("%d", ...
                game.dealerScoreCount));

        end

        % Update player display
        set(game.playerBox, 'String', sprintf("Your cards: \n %s", ...
            display_cards(game.playerCards)));
        set(game.playerCurrent, 'String', sprintf("%d", ...
                game.playerScoreCount));

        % Update result label
        set(game.winlose, 'String', game.result);
        set(game.winlose1, 'String', game.result1);

        % Update score for player
        set(game.playerScore, 'String', sprintf('Player Wins: %d', ...
            game.playerWins));

           % Update score for dealer
        set(game.dealerScore, 'String', sprintf('Dealer Wins: %d',
            game.dealerWins));

endfunction

function playerHit()
        sound(y, fs);
        if game.playerTurn == true
            set(game.dealerCurrent, 'Visible', 'off');
            [game.playerCards, game.deck] = cardDraw(game.playerCards, game.deck);
            game.playerScoreCount = calculateScore(game.playerCards);
            if game.playerScoreCount > 21
                game.result = "You busted!\n Please press PLAY GAME button and then HIT button to play";
                game.result1 = "Prof:\n Haha you just lost 10% \n of your final grade :)";
                game.dealerWins = game.dealerWins + 1;
                game.playerTurn = false;
                set(game.hitButton, 'Visible', 'off');
                 set(game.stayButton, 'Visible', 'off');
                 set(game.playagainButton, 'Visible', 'on');
                 updateScreen()

            else
                 updateScreen();
            end
        end
    endfunction


%Stay button implementation, if clicked, change player turn to false and run function for dealer play
function playerStand()
        if game.playerTurn == true
            game.playerTurn = false;
            dealerPlay();
        end
    endfunction


function dealerPlay()
        % automatization of card draw while dealer score is less than 17, same logic as for player
        while game.dealerScoreCount < 17
            [game.dealerCards, game.deck] = cardDraw(game.dealerCards, game.deck);
            game.dealerScoreCount = calculateScore(game.dealerCards);
        end

        % Check who is the winner and update global scores for player and dealer, option for tie implemented
        if game.dealerScoreCount > 21 || game.playerScoreCount > game.dealerScoreCount
            game.result = "You win!\n Please press PLAY GAME button and then HIT button to play";
            game.result1 = "Prof:\n Wow, you managed to earn \n yourself bonus points.";
            game.playerWins = game.playerWins + 1;
             set(game.hitButton, 'Visible', 'off');
        set(game.stayButton, 'Visible', 'off');
        set(game.playagainButton, 'Visible', 'on');
        set(game.dealerCurrent, 'Visible', 'on');


        elseif game.playerScoreCount < game.dealerScoreCount
            game.result = "Dealer wins.\n Please press PLAY GAME button and then HIT button to play";
            game.result1 = "Prof:\n Haha you just lost 10% \n of your final grade :)";
            game.dealerWins = game.dealerWins + 1;
             set(game.hitButton, 'Visible', 'off');
        set(game.stayButton, 'Visible', 'off');
        set(game.playagainButton, 'Visible', 'on');
        set(game.dealerCurrent, 'Visible', 'on');


        else
            game.result = "It's a tie!\n Please press PLAY GAME button and then HIT button to play";
            game.result1 = "Prof:\n Better luck next time ;)";
             set(game.hitButton, 'Visible', 'off');
        set(game.stayButton, 'Visible', 'off');
        set(game.playagainButton, 'Visible', 'on');
        set(game.dealerCurrent, 'Visible', 'on');

        end
        updateScreen();
    endfunction


%draw from deck system
function [myhand, deck] = cardDraw(myhand, deck)
    myhand = [myhand, deck(1)]; % Add the top card to the hand
    deck(1) = []; % Remove the top card from the deck
endfunction



%score calculation system
function currentScore = calculateScore(cards)
    currentScore = sum(cards);
    while currentScore > 21 && any(cards == 11)
        cards(cards == 11) = 1;  % Convert Ace from 11 to 1 if score is over 21
        currentScore = sum(cards);
    end
endfunction

%Important!
function string = display_cards(cards)
    string = strjoin(arrayfun(@display_card, cards, 'UniformOutput', false), ', ');
endfunction

%convert 10 values to display as faces or standard 10, and 11 as Ace
function str = display_card(card)
        if card == 11
        imshow(deck, 'Parent', ax2);
        imshow(c1, 'Parent', ax);
        str='A'
    elseif card == 10
        imshow(deck, 'Parent', ax2);
        imshow(c10, 'Parent', ax);
        str='10';
     elseif card == 2
        imshow(deck, 'Parent', ax2);
        imshow(c2, 'Parent', ax);
        str='2';
      elseif card == 3
        imshow(deck, 'Parent', ax2);
        imshow(c3, 'Parent', ax);
        str='3';
      elseif card == 4
        imshow(deck, 'Parent', ax2);
        imshow(c4, 'Parent', ax);
        str='4';
      elseif card == 5
        imshow(deck, 'Parent', ax2);
        imshow(c5, 'Parent', ax);
        str='5';
      elseif card == 6
        imshow(deck, 'Parent', ax2);
        imshow(c6, 'Parent', ax);
        str='6';
      elseif card == 7
        imshow(deck, 'Parent', ax2);
        imshow(c7, 'Parent', ax);
        str='7';
      elseif card == 8
        imshow(deck, 'Parent', ax2);
        imshow(c8, 'Parent', ax);
        str='8';
      elseif card == 9
        imshow(deck, 'Parent', ax2);
        imshow(c9, 'Parent', ax);
        str='9';
    else
        str = num2str(card);
    end


endfunction



function str1 = display_card1(card)
        if card == 11
        imshow(deck, 'Parent', ax4);
        imshow(c1, 'Parent', ax3);
        str1='A'
    elseif card == 10
        imshow(deck, 'Parent', ax4);
        imshow(c10, 'Parent', ax3);
        str1='10';
     elseif card == 2
        imshow(deck, 'Parent', ax4);
        imshow(c2, 'Parent', ax3);
        str1='2';
      elseif card == 3
        imshow(deck, 'Parent', ax4);
        imshow(c3, 'Parent', ax3);
        str1='3';
      elseif card == 4
        imshow(deck, 'Parent', ax4);
        imshow(c4, 'Parent', ax3);
        str1='4';
      elseif card == 5
        imshow(deck, 'Parent', ax4);
        imshow(c5, 'Parent', ax3);
        str1='5';
      elseif card == 6
        imshow(deck, 'Parent', ax4);
        imshow(c6, 'Parent', ax3);
        str1='6';
      elseif card == 7
        imshow(deck, 'Parent', ax4);
        imshow(c7, 'Parent', ax3);
        str1='7';
      elseif card == 8
        imshow(deck, 'Parent', ax4);
        imshow(c8, 'Parent', ax3);
        str1='8';
      elseif card == 9
        imshow(deck, 'Parent', ax4);
        imshow(c9, 'Parent', ax3);
        str1='9';
    else
        str1 = num2str(card);
    end


endfunction



endfunction
