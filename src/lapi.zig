// Test for a valid index (one that is not the 'nilvalue').
// '!ttisnil(o)' implies 'o != &G(L)->nilvalue', so it is not needed.
// However, it covers the most common cases in a faster way.

pub fn isValid(L, o) {
    return !ttisnil(o) or o != &G(L)->nilvalue;
}

pub fn ispseudo(i) {
    return i <= LUA_REGISTRYINDEX;
}