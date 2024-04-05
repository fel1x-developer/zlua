const luaconf = @import("luaconf.zig");
const lstate = @import("lstate.zig");
const lapi = @import("lapi.zig");

const LUA_COPYRIGHT = LUA_RELEASE ++ "  Copyright (C) 1994-2023 Lua.org, PUC-Rio";
const LUA_AUTHORS = "R. Ierusalimschy, L. H. de Figueiredo, W. Celes";

const LUA_VERSION_MAJOR_N = 5;
const LUA_VERSION_MINOR_N = 5;
const LUA_VERSION_RELEASE_N = 0;

const LUA_VERSION_NUM = LUA_VERSION_MAJOR_N * 100 + LUA_VERSION_MINOR_N;
const LUA_VERSION_RELEASE_NUM = LUA_VERSION_NUM * 100 + LUA_VERSION_RELEASE_N;

// mark for precompiled code ('<esc>Lua')
const LUA_SIGNATURE = "\x1bLua";

// option for multiple returns in 'lua_pcall' and 'lua_call'
const LUA_MULTRET = -1;

// Pseudo-indices
// (-LUAI_MAXSTACK is the minimum valid index; we keep some free empty
// space after that to help overflow detection)
const LUA_REGISTRYINDEX = -luaconf.LUAI_MAXSTACK - 1000;
pub fn lua_upvalueindex(i: anytype) @TypeOf(i) {
    return LUA_REGISTRYINDEX - i;
}

// thread status
const LUA_OK = 0;
const LUA_YIELD = 1;
const LUA_ERRRUN = 2;
const LUA_ERRSYNTAX = 3;
const LUA_ERRMEM = 4;
const LUA_ERRERR = 5;

const lua_State = lstate.lua_State;

// basic types
const LUA_TNONE: comptime_int = -1;

const LUA_TNIL = 0;
const LUA_TBOOLEAN = 1;
const LUA_TLIGHTUSERDATA = 2;
const LUA_TNUMBER = 3;
const LUA_TSTRING = 4;
const LUA_TTABLE = 5;
const LUA_TFUNCTION = 6;
const LUA_TUSERDATA = 7;
const LUA_TTHREAD = 8;

const LUA_NUMTYPES = 9;

// minimum Lua stack available to a C function
const LUA_MINSTACK = 20;

// predefined values in the registry
// index 1 is reserved for the reference mechanism
const LUA_RIDX_GLOBALS = 2;
const LUA_RIDX_MAINTHREAD = 3;
const LUA_RIDX_LAST = 3;

// type of numbers in Lua
const lua_Number = luaconf.LUA_NUMBER;

// type for integer functions
const lua_Integer = luaconf.LUA_INTEGER;

// unsigned integer type
const lua_Unsigned = luaconf.LUA_UNSIGNED;

// type for continuation-function contexts
const lua_KContext = luaconf.LUA_KCONTEXT;

// Type for C functions registered with Lua
const lua_CFunction = fn (L: *lua_State) i32;

// Type for continuation functions
const lua_KFunction = fn (L: *lua_State, status: i32, ctx: lua_KContext) i32;

// Type for functions that read/write blocks when loading/dumping Lua chunks
const lua_Reader = fn (L: *lua_State, ud: *anyopaque, sz: *usize) *[]const u8;

const lua_Writer = fn (L: *lua_State, p: *const anyopaque, sz: usize, ud: *anyopaque) i32;

// Type for memory-allocation functions
const lua_Alloc = fn (ud: *anyopaque, ptr: *anyopaque, osize: usize, nsize: usize) void;

// Type for warning functions
const lua_WarnFunction = fn (ud: *anyopaque, msg: *[]const u8, tocont: i32) void;

// Type used by the debug API to collect debug information
const lua_Debug = luaconf.lua_Debug;

// Functions to be called by the debugger in specific events
const lua_Hook = fn (L: *lua_State, ar: *lua_Debug) void;

// RCS ident string
const lua_ident = lapi.lua_ident;

// state manipulation
pub export fn lua_newstate(f: lua_Alloc, ud: *anyopaque, seed: u32) *lua_State;
pub export fn lua_close(L: *lua_State) void;
pub export fn lua_newthread(L: *lua_State) *lua_State;
pub export fn lua_closethread(L: *lua_State, from: *lua_State) i32;

pub export fn lua_atpanic(L: *lua_State, panicf: lua_CFunction) lua_CFunction;

pub export fn lua_version(L: *lua_State) lua_Number;

// basic stack manipulation
pub export fn lua_absindex(L: *lua_State, idx: i32) i32;
pub export fn lua_gettop(L: *lua_State) i32;
pub export fn lua_settop(L: *lua_State, idx: i32) void;
pub export fn lua_pushvalue(L: *lua_State, idx: i32) void;
pub export fn lua_rotate(L: *lua_State, idx: i32, n: i32) void;
pub export fn lua_copy(L: *lua_State, fromidx: i32, toidx: i32) void;
pub export fn lua_checkstack(L: *lua_State, n: i32) i32;

pub export fn lua_xmove(from: *lua_State, to: *lua_State, n: i32) void;

// access functions (stack -> C)
pub export fn lua_isnumber(L: *lua_State, idx: i32) i32;
pub export fn lua_isstring(L: *lua_State, idx: i32) i32;
pub export fn lua_iscfunction(L: *lua_State, idx: i32) i32;
pub export fn lua_isinteger(L: *lua_State, idx: i32) i32;
pub export fn lua_isuserdata(L: *lua_State, idx: i32) i32;
pub export fn lua_type(L: *lua_State, idx: i32) i32;
pub export fn lua_typename(L: *lua_State, tp: i32) *[]const u8;

pub export fn lua_tonumberx(L: *lua_State, idx: i32, isnum: *i32) lua_Number;
pub export fn lua_tointegerx(L: *lua_State, idx: i32, isnum: *i32) lua_Integer;
pub export fn lua_toboolean(L: *lua_State, idx: i32) i32;
pub export fn lua_tolstring(L: *lua_State, idx: i32, len: *usize) *[]const u8;
pub export fn lua_rawlen(L: *lua_State, idx: i32) lua_Unsigned;
pub export fn lua_tocfunction(L: *lua_State, idx: i32) lua_CFunction;
pub export fn lua_touserdata(L: *lua_State, idx: i32) *anyopaque;
pub export fn lua_tothread(L: *lua_State, idx: i32) *lua_State;
pub export fn lua_topointer(L: *lua_State, idx: i32) *const anyopaque;

// Comparison and arithmetic functions
const LUA_OPADD = 0; // ORDER TM, ORDER OP
const LUA_OPSUB = 1;
const LUA_OPMUL = 2;
const LUA_OPMOD = 3;
const LUA_OPPOW = 4;
const LUA_OPDIV = 5;
const LUA_OPIDIV = 6;
const LUA_OPBAND = 7;
const LUA_OPBOR = 8;
const LUA_OPBXOR = 9;
const LUA_OPSHL = 10;
const LUA_OPSHR = 11;
const LUA_OPUNM = 12;
const LUA_OPBNOT = 13;

pub export fn lua_arith(L: *lua_State, op: i32) void;

const LUA_OPEQ = 0;
const LUA_OPLT = 1;
const LUA_OPLE = 2;

pub export fn lua_rawequal(L: *lua_State, idx1: i32, idx2: i32) i32;
pub export fn lua_compare(L: *lua_State, idx1: i32, idx2: i32, op: i32) i32;

// push functions (C -> stack)
pub export fn lua_pushnil(L: *lua_State) void;
pub export fn lua_pushnumber(L: *lua_State, n: lua_Number) void;
pub export fn lua_pushinteger(L: *lua_State, n: lua_Integer) void;
pub export fn lua_pushlstring(L: *lua_State, s: *[]const u8, len: usize) *[]const u8;
pub export fn lua_pushextlstring(L: *lua_State, s: *[]const u8, len: usize, falloc: lua_Alloc, ud: *anyopaque) *[]const u8;
pub export fn lua_pushstring(L: *lua_State, s: *[]const u8) *[]const u8;
pub export fn lua_pushvfstring(L: *lua_State, fmt: *[]const u8, argp: va_list) *[]const u8;
pub export fn lua_pushfstring(L: *lua_State, fmt: *[]const u8, ...) *[]const u8;
pub export fn lua_pushcclosure(L: *lua_State, @"fn": lua_CFunction, n: i32) void;
pub export fn lua_pushboolean(L: *lua_State, b: i32) void;
pub export fn lua_pushlightuserdata(L: *lua_State, p: *anyopaque) void;
pub export fn lua_pushthread(L: *lua_State) i32;

// get functions (Lua -> stack)
LUA_API int (lua_getglobal) (L: *lua_State, const char *name);
LUA_API int (lua_gettable) (L: *lua_State, int idx);
LUA_API int (lua_getfield) (L: *lua_State, int idx, const char *k);
LUA_API int (lua_geti) (L: *lua_State, int idx, lua_Integer n);
LUA_API int (lua_rawget) (L: *lua_State, int idx);
LUA_API int (lua_rawgeti) (L: *lua_State, int idx, lua_Integer n);
LUA_API int (lua_rawgetp) (L: *lua_State, int idx, const void *p);

LUA_API void  (lua_createtable) (L: *lua_State, unsigned narr, unsigned nrec);
LUA_API void *(lua_newuserdatauv) (L: *lua_State, size_t sz, int nuvalue);
LUA_API int   (lua_getmetatable) (L: *lua_State, int objindex);
LUA_API int  (lua_getiuservalue) (L: *lua_State, int idx, int n);