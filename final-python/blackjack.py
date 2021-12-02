import os
import random
import discord
from discord.ext import commands
#import pydealer - library is old and outdated so made my own

print(f"{discord.__version__}\nVersion 2021.11.22") # print versioning info on launch
bot = commands.Bot(command_prefix="bj.") # defines the bot object
TOKEN = open("TOKEN.txt", "r").readline() # reads the discord api secret token used by the bot from the local directory

suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

class Card:
    def __init__(self, name, value, value2 = 0):
        self.name = name # name of the card
        self.value = value # card value
        self.value2 = value2 # secondary value, for aces

class Deck:
    def __init__(self):
        self.cards = []
        for suit in suits:
            self.cards.append(Card(f"2 of {suit}","2"))
            self.cards.append(Card(f"3 of {suit}","3"))
            self.cards.append(Card(f"4 of {suit}","4"))
            self.cards.append(Card(f"5 of {suit}","5"))
            self.cards.append(Card(f"6 of {suit}","6"))
            self.cards.append(Card(f"7 of {suit}","7"))
            self.cards.append(Card(f"8 of {suit}","8"))
            self.cards.append(Card(f"9 of {suit}","9"))
            self.cards.append(Card(f"10 of {suit}","10"))
            self.cards.append(Card(f"Jack of {suit}","10"))
            self.cards.append(Card(f"Queen of {suit}","10"))
            self.cards.append(Card(f"King of {suit}","10"))
            self.cards.append(Card(f"Ace of {suit}","1","11"))

    def shuffle(self): # method to shuffle cards
        random.shuffle(self.cards)

    def deal(self): # take a card from "top" of the deck, or last array element, and remove it from the deck
        if len(self.cards) < 1: # regenerate deck if we somehow run out of cards
            self.__init__()
        card = self.cards[len(self.cards) - 1]
        self.cards.remove(card)
        return card

def get_card_value(stack):
    total_value = 0 # total value with aces applied as 1
    total_value2 = 0 # total value with aces applied as 11

    for card in stack:
        total_value += int(card.value) # add card value to total_value
        if card.value2 != 0: # if the card is an ace
            total_value2 += int(card.value2) # add card value to total_value
        else:
            total_value2 += int(card.value) # if its not an ace, just add regular value
    
    if total_value2 > 21:
        total_value2 = 0 # discard total_value2 if it's a bust

    return [total_value, total_value2] # return a list with total values of aces applied in both ways

class Game:
    def __init__(self, embed, opponent, message):
        self.deck = Deck() # new deck object
        self.deck.shuffle() # shuffle the deck
        self.opponents = [] # array of opponents, default to whoever instantiated the game
        self.opponents.append([opponent,[],""]) # each opponent will have the discord user and the cards associated with them. string variable is the "status", which will correspond to bust stand or blackjack.
        self.embed = embed # embed object used inside message
        self.message = message # discord message object, used for pushing embed edits
        self.cards = [] # keep track of dealer/bot cards
        self.dealer_status = "" # equivalent to third variable in each opponent entry; bust, win, etc.
        self.embed.add_field(name="Current Players - Waiting to Start", value="Dealer\n{} (Host)".format(opponent.name))

    async def add_player(self, opponent): # command to add a new player to the pool
        self.embed.clear_fields() # remove previous fields
        self.opponents.append([opponent,[],""])
        player_list = ""
        for i, opponent in enumerate(self.opponents):
            if i == 0:
                player_list += opponent[0].name + " (Host)\n"
            else:
                player_list += opponent[0].name + "\n"
        self.embed.add_field(name="Current Players - Waiting to Start", value="Dealer\n{}".format(player_list))
        await self.message.edit(embed=self.embed, view=PreGameButtons(self))

    async def start_game(self):
        self.embed.clear_fields() # remove previous fields
        # Deal two cards to opponents and self; we're doing one at a time to go "around" each player.
        for opponent in self.opponents:
            opponent[1].append(self.deck.deal())
        self.cards.append(self.deck.deal())
        for opponent in self.opponents:
            opponent[1].append(self.deck.deal())
        self.cards.append(self.deck.deal())

        value2 = ""

        if self.cards[0].value2 != 0:
            value2 = "/" + self.cards[0].value2

        # put embed together
        self.embed.insert_field_at(0,name=f"[{self.cards[0].value}{value2} + ?] Dealer Cards",value=f"[{self.cards[0].value}{value2}] {self.cards[0].name}\n[?] Hidden",inline=True) # keeping hold card hidden, as blackjack rules intend
        
        for i, opponent in enumerate(self.opponents): # handle each opponent
            total_value = get_card_value(opponent[1])
            card_list = ""
            total_value2str = ""

            for card in opponent[1]:
                card_value2 = ""
                if card.value2 != 0: # if the card is an ace
                    card_value2 = "/" + card.value2 # for localization below
                card_list += "[" + card.value + card_value2 + "] " + card.name + "\n"
            
            if total_value[0] != total_value[1] and total_value[1] <= 21: # if player has an ace and total valuation with ace applied is less than 21, show both card values
                total_value2str = "/" + str(total_value[1])

            if total_value[0] == 21 or total_value[1] == 21:
                opponent[2] = "- BLACKJACK"

            self.embed.insert_field_at(i+1,name=f"[{total_value[0]}{total_value2str}] {opponent[0].name} Cards {opponent[2]}",value=f"{card_list}",inline=True)
        
        await self.message.edit(embed=self.embed, view=BlackjackButtons(self)) # update embed and set the in-game

    async def hit(self, player): # function for a player hitting
        opponent = self.opponents[player]
        
        self.embed.remove_field(player+1) # remove old field pertaining to this player
        opponent[1].append(self.deck.deal()) # deal the new card
        
        total_value = get_card_value(opponent[1])
        card_list = ""
        total_value2str = ""

        for card in opponent[1]:
            card_value2 = ""
            if card.value2 != 0: # if the card is an ace
                card_value2 = "/" + card.value2 # for localization below
            card_list += "[" + card.value + card_value2 + "] " + card.name + "\n"
        
        if total_value[0] != total_value[1] and total_value[1] <= 21: # if player has an ace and total valuation with ace applied is less than 21, show both card values
            total_value2str = "/" + str(total_value[1])

        if total_value[0] == 21 or total_value[1] == 21:
            opponent[2] = "- BLACKJACK"

        if total_value[0] > 21:
            opponent[2] = "- Bust"

        self.embed.insert_field_at(player+1,name=f"[{total_value[0]}{total_value2str}] {opponent[0].name} Cards {opponent[2]}",value=f"{card_list}",inline=True)
        
        cond_end = True
        for player in self.opponents:
            if player[2] == "":
                cond_end = False # basically, every time someone plays make sure someone is still in play, otherwise run the dealer_reveal function (dealer plays)

        if cond_end:
            await self.dealer_reveal()

        await self.message.edit(embed=self.embed, view=BlackjackButtons(self)) # update embed and set the in-game

    async def stand(self, player): # function to stand
        opponent = self.opponents[player]
        
        self.embed.remove_field(player+1) # remove old field pertaining to this player
        opponent[2] = "- Stand"

        total_value = get_card_value(opponent[1])
        card_list = ""
        total_value2str = ""

        for card in opponent[1]:
            card_value2 = ""
            if card.value2 != 0: # if the card is an ace
                card_value2 = "/" + card.value2 # for localization below
            card_list += "[" + card.value + card_value2 + "] " + card.name + "\n"
        
        if total_value[0] != total_value[1] and total_value[1] <= 21: # if player has an ace and total valuation with ace applied is less than 21, show both card values
            total_value2str = "/" + str(total_value[1])

        self.embed.insert_field_at(player+1,name=f"[{total_value[0]}{total_value2str}] {opponent[0].name} Cards {opponent[2]}",value=f"{card_list}",inline=True)

        cond_end = True
        for player in self.opponents:
            if player[2] == "":
                cond_end = False

        if cond_end:
            await self.dealer_reveal()

        await self.message.edit(embed=self.embed, view=BlackjackButtons(self)) # update embed and set the in-game
    
    async def dealer_reveal(self):
        self.embed.remove_field(0) # remove old field pertaining to dealer

        total_value = get_card_value(self.cards)
        total_value2str = ""
        card_value2 = ""

        card_list = ""

        for card in self.cards:
            if card.value2 != 0: # if the card is an ace
                card_value2 = "/" + card.value2 # for localization below

            card_list += "[" + card.value + card_value2 + "] " + card.name + "\n"
        
        if total_value[0] != total_value[1] and total_value[1] <= 21: # if player has an ace and total valuation with ace applied is less than 21, show both card values
            total_value2str = "/" + str(total_value[1])

        if total_value[0] == 21 or total_value[1] == 21:
            self.dealer_status = "- BLACKJACK"

        if total_value[0] > 21:
            self.dealer_status = "- Bust"

        self.embed.insert_field_at(0,name=f"[{total_value[0]}{total_value2str}] Dealer Cards {self.dealer_status}",value=f"{card_list}",inline=True)

        all_players_busted = True
        for player in self.opponents: # first make sure all players haven't busted
            if player[2] != "- Bust":
                all_players_busted = False

        player_standing_greater = False
        for player in self.opponents: # next make sure player(s) aren't standing with a lower card valuation than dealer
            if player[2] == "- Stand" and get_card_value(player[1])[0] >= get_card_value(self.cards)[0] or get_card_value(player[1])[1] >= get_card_value(self.cards)[1]:
                player_standing_greater = True
        
        if self.dealer_status == "- Bust":
            await self.dealer_loses()
        else:
            if self.dealer_status == "- BLACKJACK" or all_players_busted and not player_standing_greater: # easy win condition for dealer, else dealer hit
                await self.dealer_wins()
            else:
                await self.dealer_hit()

            await self.message.edit(embed=self.embed) # update embed and set the in-game

    async def dealer_loses(self):
        self.embed.remove_field(0) # remove old field pertaining to dealer

        total_value = get_card_value(self.cards)
        total_value2str = ""
        card_value2 = ""

        card_list = ""

        for card in self.cards:
            if card.value2 != 0: # if the card is an ace
                card_value2 = "/" + card.value2 # for localization below

            card_list += "[" + card.value + card_value2 + "] " + card.name + "\n"
        
        if total_value[0] != total_value[1] and total_value[1] <= 21: # if player has an ace and total valuation with ace applied is less than 21, show both card values
            total_value2str = "/" + str(total_value[1])

        self.embed.insert_field_at(0,name=f"[{total_value[0]}{total_value2str}] Dealer Loses {self.dealer_status}",value=f"{card_list}",inline=True)

        await self.message.edit(embed=self.embed) # update embed

    async def dealer_wins(self):
        self.embed.remove_field(0) # remove old field pertaining to dealer

        total_value = get_card_value(self.cards)
        total_value2str = ""
        card_value2 = ""

        card_list = ""

        for card in self.cards:
            if card.value2 != 0: # if the card is an ace
                card_value2 = "/" + card.value2 # for localization below

            card_list += "[" + card.value + card_value2 + "] " + card.name + "\n"
        
        if total_value[0] != total_value[1] and total_value[1] <= 21: # if player has an ace and total valuation with ace applied is less than 21, show both card values
            total_value2str = "/" + str(total_value[1])

        self.embed.insert_field_at(0,name=f"[{total_value[0]}{total_value2str}] Dealer Wins! {self.dealer_status}",value=f"{card_list}",inline=True)

        await self.message.edit(embed=self.embed) # update embed
    
    async def dealer_hit(self):
        self.embed.remove_field(0) # remove old field pertaining to dealer

        self.cards.append(self.deck.deal())

        total_value = get_card_value(self.cards)
        total_value2str = ""
        card_value2 = ""

        card_list = ""

        for card in self.cards:
            if card.value2 != 0: # if the card is an ace
                card_value2 = "/" + card.value2 # for localization below

            card_list += "[" + card.value + card_value2 + "] " + card.name + "\n"
        
        if total_value[0] != total_value[1] and total_value[1] <= 21: # if player has an ace and total valuation with ace applied is less than 21, show both card values
            total_value2str = "/" + str(total_value[1])

        if total_value[0] == 21 or total_value[1] == 21:
            self.dealer_status = "- BLACKJACK"

        if total_value[0] > 21:
            self.dealer_status = "- Bust"

        self.embed.insert_field_at(0,name=f"[{total_value[0]}{total_value2str}] Dealer Cards {self.dealer_status}",value=f"{card_list}",inline=True)

        await self.dealer_reveal() # check if dealer wins/loses or if we have to hit again

        await self.message.edit(embed=self.embed) # update embed and set the in-game

class PreGameButtons(discord.ui.View):
    def __init__(self, game):
        super().__init__()
        self.game = game

    @discord.ui.button(label="Start Game", style=discord.ButtonStyle.green)
    async def start(self, button: discord.ui.Button, interaction: discord.Interaction):
        if self.game.opponents[0][0] == interaction.user: # if the person pressing button is host, start game 
            await self.game.start_game()
        else: # else, send them an ephemeral message to fuck off
            await interaction.response.send_message('Only the host may start the game!', ephemeral=True)
    
    @discord.ui.button(label="Join Game", style=discord.ButtonStyle.blurple)
    async def join(self, button: discord.ui.Button, interaction: discord.Interaction):
        if len(self.game.opponents) >= 6:
            await interaction.response.send_message('This game is full, there can be a maximum of six players plus the dealer.', ephemeral=True)
            return
        for opponent in self.game.opponents:
            if opponent[0] == interaction.user: # if player is already in game dont let them join
                await interaction.response.send_message('You are already in this game!', ephemeral=True)
                return
        await self.game.add_player(interaction.user)
    
    @discord.ui.button(label="Disband Game", style=discord.ButtonStyle.red)
    async def disband(self, button: discord.ui.Button, interaction: discord.Interaction):
        if self.game.opponents[0][0] == interaction.user: # if the person pressing button is host, disband the game
            await self.game.message.delete() # delete the message effectively ending the game.
        else: # otherwise do nothing
            await interaction.response.send_message('Only the host may disband the game!', ephemeral=True)

class BlackjackButtons(discord.ui.View):
    def __init__(self, game):
        super().__init__()
        self.game = game
    @discord.ui.button(label="Hit", style=discord.ButtonStyle.blurple)
    async def hit(self, button: discord.ui.Button, interaction: discord.Interaction):
        for i, opponent in enumerate(self.game.opponents):
            if opponent[0] == interaction.user: # if player is in the game
                if opponent[2] == "": # make sure player hasnt won, stand, or busted
                    await self.game.hit(i)
                    return
                else: # if they have, tell them they cant play
                    await interaction.response.send_message('You have already played your hand!', ephemeral=True)
                    return
        await interaction.response.send_message('You are not a member of this game!', ephemeral=True)
    
    @discord.ui.button(label="Stand", style=discord.ButtonStyle.blurple)
    async def stand(self, button: discord.ui.Button, interaction: discord.Interaction):
        for i, opponent in enumerate(self.game.opponents):
            if opponent[0] == interaction.user: # if player is in the game
                if opponent[2] == "": # make sure player hasnt won, stand, or busted
                    await self.game.stand(i)
                    return
                else: # if they have, tell them they cant play
                    await interaction.response.send_message('You have already played your hand!', ephemeral=True)
                    return
        await interaction.response.send_message('You are not a member of this game!', ephemeral=True)
        
@bot.event
async def on_ready():
    print(f"Logged in as {bot.user}")

@bot.command()
async def new(ctx):
    await ctx.message.delete()
    embed = discord.Embed(title="Blackjack", description="Blackjack (also known as 21) is a game where players try to reach a total card value of 21. If nobody reaches 21, the player with the highest card value not exceeding 21 wins. If a player exceeds 21, it is a \"bust\".", color=0xcc0000)
    msg = await ctx.send(embed=embed)
    game = Game(embed, ctx.author, msg)
    await msg.edit(embed=embed, view=PreGameButtons(game)) # edit message to include join game button

# Run the bot
bot.run(TOKEN)