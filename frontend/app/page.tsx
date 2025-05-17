"use client";
import { useState } from "react";

export default function Home() {
  const [prompt, setPrompt] = useState("");
  const [response, setResponse] = useState("");
  const [error, setError] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const handleSend = async () => {
    try {
      setIsLoading(true);
      setError("");
      setResponse("");

      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/gemini`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ prompt }),
      });

      const data = await res.json();

      if (!res.ok) {
        setError(data.error || "エラーが発生しました。");
        return;
      }

      setResponse(JSON.stringify(data, null, 2));
    } catch (err) {
      setError("通信エラーが発生しました。");
      console.error(err);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="p-8 max-w-xl mx-auto">
      <h1 className="text-2xl mb-4">Gemini Demo</h1>
      <textarea
        className="border p-2 w-full"
        value={prompt}
        onChange={(e) => setPrompt(e.target.value)}
        rows={4}
        placeholder="質問を入力"
        disabled={isLoading}
      />
      <button
        onClick={handleSend}
        className={`${
          isLoading ? "bg-gray-400" : "bg-blue-600"
        } text-white px-4 py-2 mt-2 rounded`}
        disabled={isLoading}
      >
        {isLoading ? "送信中..." : "送信"}
      </button>
      {error && (
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 mt-4 rounded">
          {error}
        </div>
      )}
      {response && <pre className="bg-gray-100 p-4 mt-4">{response}</pre>}
    </div>
  );
}
