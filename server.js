'use strict';

const express = require('express')
const { graphqlHTTP } = require('express-graphql');
const morgan = require('morgan')
const morganBody = require("morgan-body")

const {
    GraphQLSchema,
    GraphQLObjectType,
    GraphQLString,
    GraphQLList,
    GraphQLInt,
    GraphQLNonNull
} = require('graphql')
const app = express()

const characters = [
	{ id: 1, name: 'Light' },
    { id: 2, name: 'L' },
	{ id: 3, name: 'Eren' },
	{ id: 4, name: 'Kakashi' },
    { id: 5, name: 'Near' },
    { id: 6, name: 'Trunks' },
    { id: 7, name: 'Naruto' },
    { id: 8, name: 'Monkey D. Luffy' },
    { id: 9, name: 'Levi' }
]

const animes = [
	{ id: 1, name: 'Deathnote', characterId: 1 },
	{ id: 2, name: 'Deathnote', characterId: 2 },
	{ id: 3, name: 'AOT', characterId: 3 },
	{ id: 4, name: 'Naruto', characterId: 4 },
	{ id: 5, name: 'Deathnote', characterId: 5 },
	{ id: 6, name: 'DBZ', characterId: 6 },
	{ id: 7, name: 'Naruto', characterId: 7 },
	{ id: 8, name: 'One Piece', characterId: 8 },
    { id: 8, name: 'AOT', characterId: 9 }
]

const CharacterType = new GraphQLObjectType({
    name: 'Character',
    description: 'This reps a Character in a Anime',
    fields: () => ({
        id: { type: new GraphQLNonNull(GraphQLInt) },
        name: { type: new GraphQLNonNull(GraphQLString) }
    })
})

const AnimeType = new GraphQLObjectType({
    name: 'Anime',
    description: 'This reps an Anime which has this Character',
    fields: () => ({
        id: { type: new GraphQLNonNull(GraphQLInt) },
        name: { type: new GraphQLNonNull(GraphQLString) },
        characterId: { type: new GraphQLNonNull(GraphQLInt) },
        character: { 
            type: CharacterType,
            resolve: (anime) => {
                return characters.find(character => character.id === anime.characterId)
            }
        }
    })
})

const CharacterRemove = new GraphQLObjectType({
    name: 'Character',
    description: 'This reps a Character in a Anime',
    fields: () => ({
        id: { type: new GraphQLNonNull(GraphQLInt) },
        character: {
            type: GraphQLInt,
            resolve: character => {
                return characters.filter((item) => {
                    if (item.id !== character.id) {
                        return item
                    }
                })
            }
        }
    })
})

const RootQueryType = new GraphQLObjectType({
    name: 'Query',
    description: 'Root Query',
    fields: () => ({
        animes: {
            type: new GraphQLList(AnimeType),
            description: 'List of All Animes',
            resolve: () => animes
        }
    })
})
 
const schema = new GraphQLSchema({
    query: RootQueryType
})


morganBody(app, {
    logAllReqHeader:true, 
    prettify:true,
    immediateReqLog:true
});
// app.use(morgan('dev'))
app.use('/graphql', graphqlHTTP({
    schema: schema,
    graphiql: true
}))

app.post('/', express.json(), function(req, res) {
    console.log(req.headers);
    console.log(req.body);
    res.send({body: req.body});
});

app.listen(3000., () => console.log('Server running'))
app.listen(5000., () => console.log('Server running'));