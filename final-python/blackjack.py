import os
import random
import discord
import pydealer

print(f"{discord.__version__}\nVersion 2021.11.22") # print versioning info on launch
bot = discord.Client() # defines the bot object
TOKEN = "NjY4OTgyNTkyMTI0NDg1Njcy.XiZMlw.tNr7rJXsKqe_V39FKeCgJEQ3AzI"
# TOKEN = open("TOKEN.txt", "r").readline() # reads the discord api secret token used by the bot from the local directory
LISTENING_CHANNEL = 912517765259206666 # channel the bot listens to and interacts with

class Game:
    def __init__(self, opponent):
        self.deck = pydealer.Deck() # create a new deck instance for this specific game
        self.deck.shuffle() # shuffle the deck
        self.opponent = opponent

    def dealToPlayer(self):
        return self.deck.deal(2)

currentGames = []

@bot.event
async def on_message(message):
    if message.author == bot.user:
        return
    
    if message.content == '!blackjack':
        game = Game(message.author)
        response = game.dealToPlayer()
        await message.channel.send(response)

# Run the bot
bot.run(TOKEN)