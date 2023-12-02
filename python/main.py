import gradio as gr
from utils import transcribe

demo = gr.Interface(
    transcribe,
    gr.Audio(sources=["microphone"]),
    [
        gr.Textbox(label="User Question"),
        gr.Textbox(label="SQL Stmt"),
        gr.Textbox(label="Answer"),
        gr.Textbox(label="Pushups"),
    ],
)

demo.launch()
