// Run with gjs and the built RWCR manager/utils.js as the first argument.
const {GLib} = imports.gi;
const [ok, bytes] = GLib.file_get_contents(ARGV[0]);
if (!ok) throw Error('Cannot read built RWCR utilities');
const source = new TextDecoder().decode(bytes);
const start = source.indexOf('function isFractionalScalingEnabled()');
if (start < 0) throw Error('RWCR scaling helper changed; review this regression test');
const end = source.indexOf('\n/**', start);
const evaluate = new Function('method', 'features', `
 let mutterSettings=null,fractionalScalingEnabled=null;
 const Gio={Settings:{new:()=>({connect:()=>{},get_strv:()=>features})}};
 const Meta=method===null?{}:{is_wayland_compositor:()=>method};
 ${source.slice(start,end)}
 return isFractionalScalingEnabled();
`);
for (const [method, flags, expected] of [
 [null,[],true], [null,['variable-refresh-rate'],true],
 [true,[],false], [true,['scale-monitor-framebuffer'],true],
 [false,[],false], [false,['scale-monitor-framebuffer'],false],
]) {
 if (evaluate(method,flags)!==expected) throw Error(JSON.stringify({method,flags,expected}));
}
print('RWCR GNOME50 logical scaling and GNOME49 Wayland/X11 cases passed');
