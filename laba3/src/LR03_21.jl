include("lab03_lib.jl")
using Images, Random, Statistics, SHA, Plots

make_scene(101) |> describe_image

img = make_scene(101; scene_preset(4)...)
describe_image(img)

g_manual = luma_manual(img)
g = luma_images(img)
maxdiff = maximum(abs.(g_manual .- g))
println("Максимальная разность яркости: ", maxdiff)


sha1 = array_sha(g)
println("SHA-256: ", sha1)

img_repeat = make_scene(101; scene_preset(4)...)
g_repeat = luma_images(img_repeat)
sha2 = array_sha(g_repeat)

println("SHA-256 при повторе: ", sha2)
println("Контрольная сумма совпала: ", sha1 == sha2)


h = apply_factor(g, 3)
println("Исходный размер: ", size(g))
println("Размер после обработки: ", size(h))

save("v21_before.png", Gray{N0f8}.(g))
save("v21_after.png", Gray{N0f8}.(h))


hist_before = bar(
    1:32, hist_counts(g, 32),
    legend=false,
    xlabel="Интервал яркости",
    ylabel="Количество пикселей",
    title="Вариант 21 - до обработки"
)
savefig(hist_before, "v21_hist_before.png")

hist_after = bar(
    1:32, hist_counts(h, 32),
    legend=false,
    xlabel="Интервал яркости",
    ylabel="Количество пикселей",
    title="Вариант 21 - после обработки"
)
savefig(hist_after, "v21_hist_after.png")


summary = variant_summary(21)

println("Вариант: ", summary.variant)
println("Номер сцены: ", summary.ctx)
println("Номер воздействия: ", summary.fac)
println("Средний PSNR: ", summary.psnr)

for row in summary.rows
    println(row)
end


for seed in 101:105
    img = make_scene(seed; scene_preset(4)...)
    g = luma_images(img)
    h = apply_factor(g, 3)

    println("Seed: ", seed)
    println("До: ", metrics3(g))
    println("После: ", metrics3(h))
    println("PSNR, дБ: ", psnr_db(g, h))
end