import os
import random
import discord
#import pydealer - library is old and outdated so made my own

print(f"{discord.__version__}\nVersion 2021.11.22") # print versioning info on launch
bot = discord.Client() # defines the bot object
TOKEN = open("TOKEN.txt", "r").readline() # reads the discord api secret token used by the bot from the local directory
LISTENING_CHANNEL = 912517765259206666 # channel the bot listens to and interacts with

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
        card = self.cards[len(self.cards) - 1]
        self.cards.remove(card)
        return card

class Game:
    def __init__(self, opponent, message):
        self.deck = Deck() # new deck object
        self.deck.shuffle() # shuffle the deck
        self.opponent = opponent
        self.message = message
        self.cards = []
        self.opponent_cards = []

        # Deal two cards to opponent and self
        self.opponent_cards.append(self.deck.deal())
        self.cards.append(self.deck.deal())
        self.opponent_cards.append(self.deck.deal())
        self.cards.append(self.deck.deal())

        #Put embed together
        self.message.add_field(name="Dealer Cards",value=f"{self.cards[0].name}\n{self.cards[1].name}",inline=True)
        self.message.add_field(name=f"{opponent.name} Cards",value=f"{self.opponent_cards[0].name}\n{self.opponent_cards[1].name}",inline=True)

currentGames = []

@bot.event
async def on_message(msg):
    if msg.author == bot.user:
        return
    
    if msg.content == '!blackjack':
        embed = discord.Embed(title="Blackjack", description="Blackjack (also known as 21) is a game where players try to reach a total card value of 21. If nobody reaches 21, the player with the highest card value not exceeding 21 wins. If a player exceeds 21, it is a \"bust\".", color=0x080808)
        game = Game(msg.author, embed)
        await msg.channel.send(embed=embed)

# Run the bot
bot.run(TOKEN)