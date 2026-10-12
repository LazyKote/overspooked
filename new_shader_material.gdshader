shader_type canvas_item;

// Угол конуса в градусах (полный раскрыв, не половина)
uniform float cone_angle_deg : hint_range(1.0, 180.0) = 60.0;
// Мягкость краёв конуса
uniform float edge_softness : hint_range(0.0, 1.0) = 0.25;
// Радиус затухания (0 — у носика, 1 — у края текстуры)
uniform float falloff_start : hint_range(0.0, 1.0) = 0.0;
uniform float falloff_end   : hint_range(0.0, 1.0) = 1.0;

void light() {
    // UV от 0 до 1. Носик фонарика — сверху по центру.
    // Вектор от носика к текущему пикселю.
    vec2 from_muzzle = UV - vec2(0.5, 0.0);

    // Угол между направлением "вниз" (0, +1) и текущим вектором.
    float ang = abs(atan(from_muzzle.x, from_muzzle.y));
    float half_cone = radians(cone_angle_deg) * 0.5;

    // Маска по углу: 1 внутри конуса, 0 снаружи, с мягким переходом
    float edge = half_cone * edge_softness;
    float angle_mask = 1.0 - smoothstep(half_cone - edge, half_cone + edge, ang);

    // Радиальное затухание — расстояние от носика.
    // Умножаем Y на 0.5, чтобы учесть, что конус вытянут вниз.
    float r = length(from_muzzle * vec2(1.0, 0.5));
    float radial = 1.0 - smoothstep(falloff_start, falloff_end, r);

    // Общая яркость пикселя
    float a = angle_mask * radial;
    
    // В функции light() мы записываем результат в LIGHT, а не в COLOR.
    // Мы задаём цвет и яркость света, который упадёт на объекты.
    LIGHT = vec4(1.0, 1.0, 1.0, a); 
}