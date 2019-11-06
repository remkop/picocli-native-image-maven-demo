package picocli.nativeimage.demo;

import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.assertEquals;

class CheckSumImageTest {

    static final String executable = "build/graal/checksum" + extension();

    private static String extension() {
        return System.getProperty("os.name").toLowerCase().startsWith("win") ? ".exe" : "";
    }

    static File createTempDataFile() throws IOException {
        File tempFile = File.createTempFile("checksum", "test");
        try (FileOutputStream fous = new FileOutputStream(tempFile)) {
            fous.write("hi\n".getBytes());
            fous.flush();
        }
        return tempFile;
    }

    @Tag("native-image")
//    @Test
//    public void testUsageHelp() throws IOException, InterruptedException {
//        Process process = new ProcessBuilder(executable, "--help").start();
//
//        String exected = String.format("" +
//                "Usage: checksum [-hV] [-a=<algorithm>] <file>%n" +
//                "Prints the checksum (MD5 by default) of a file to STDOUT.%n" +
//                "      <file>      The file whose checksum to calculate.%n" +
//                "  -a, --algorithm=<algorithm>%n" +
//                "                  MD5, SHA-1, SHA-256, ...%n" +
//                "  -h, --help      Show this help message and exit.%n" +
//                "  -V, --version   Print version information and exit.%n");
//        assertEquals(exected, getStdOut(process));
//        assertEquals("", getStdErr(process));
//        process.waitFor(3, TimeUnit.SECONDS);
//        assertEquals(0, process.exitValue());
//    }
//
//    @Test
//    public void testVersionInfo() throws IOException, InterruptedException {
//        Process process = new ProcessBuilder(executable, "--version").start();
//
//        String exected = String.format("checksum 4.0%n"); // JVM: 1.8.0_222 (Oracle Corporation Substrate VM GraalVM dev)
//
//        assertEquals(exected, getStdOut(process));
//        assertEquals("", getStdErr(process));
//        process.waitFor(3, TimeUnit.SECONDS);
//        assertEquals(0, process.exitValue());
//    }
//
//    @Test
//    public void testDefaultAlgorithm() throws IOException, InterruptedException {
//        File tempFile = createTempDataFile();
//
//        Process process = new ProcessBuilder(executable, tempFile.getAbsolutePath()).start();
//
//        String exected = String.format("764efa883dda1e11db47671c4a3bbd9e%n");
//
//        assertEquals("", getStdErr(process));
//        assertEquals(exected, getStdOut(process));
//        process.waitFor(3, TimeUnit.SECONDS);
//        assertEquals(0, process.exitValue());
//        tempFile.delete();
//    }
//
//    @Test
//    public void testMd5Algorithm() throws IOException, InterruptedException {
//        File tempFile = createTempDataFile();
//
//        Process process = new ProcessBuilder(executable, "-a", "md5", tempFile.getAbsolutePath()).start();
//
//        String exected = String.format("764efa883dda1e11db47671c4a3bbd9e%n");
//
//        assertEquals(exected, getStdOut(process));
//        assertEquals("", getStdErr(process));
//        process.waitFor(3, TimeUnit.SECONDS);
//        assertEquals(0, process.exitValue());
//        tempFile.delete();
//    }
//
//    @Test
//    public void testSha1Algorithm() throws IOException, InterruptedException {
//        File tempFile = createTempDataFile();
//
//        Process process = new ProcessBuilder(executable, "-a", "sha1", tempFile.getAbsolutePath()).start();
//
//        String exected = String.format("55ca6286e3e4f4fba5d0448333fa99fc5a404a73%n");
//
//        assertEquals(exected, getStdOut(process));
//        assertEquals("", getStdErr(process));
//        process.waitFor(3, TimeUnit.SECONDS);
//        assertEquals(0, process.exitValue());
//        tempFile.delete();
//    }
//
//    @Test
//    public void testInvalidInput_MissingRequiredArg() throws IOException, InterruptedException {
//        Process process = new ProcessBuilder(executable).start();
//
//        String exected = String.format("" +
//                "Missing required parameter: <file>%n" +
//                "Usage: checksum [-hV] [-a=<algorithm>] <file>%n" +
//                "Prints the checksum (MD5 by default) of a file to STDOUT.%n" +
//                "      <file>      The file whose checksum to calculate.%n" +
//                "  -a, --algorithm=<algorithm>%n" +
//                "                  MD5, SHA-1, SHA-256, ...%n" +
//                "  -h, --help      Show this help message and exit.%n" +
//                "  -V, --version   Print version information and exit.%n");
//        assertEquals(exected, getStdErr(process));
//        assertEquals("", getStdOut(process));
//        process.waitFor(3, TimeUnit.SECONDS);
//        assertEquals(2, process.exitValue());
//    }
//
//    @Test
//    public void testInvalidInput_UnknownOption() throws IOException, InterruptedException {
//        Process process = new ProcessBuilder(executable, "file", "--unknown").start();
//
//        String exected = String.format("" +
//                "Unknown option: '--unknown'%n" +
//                "Usage: checksum [-hV] [-a=<algorithm>] <file>%n" +
//                "Prints the checksum (MD5 by default) of a file to STDOUT.%n" +
//                "      <file>      The file whose checksum to calculate.%n" +
//                "  -a, --algorithm=<algorithm>%n" +
//                "                  MD5, SHA-1, SHA-256, ...%n" +
//                "  -h, --help      Show this help message and exit.%n" +
//                "  -V, --version   Print version information and exit.%n");
//        assertEquals(exected, getStdErr(process));
//        assertEquals("", getStdOut(process));
//        process.waitFor(3, TimeUnit.SECONDS);
//        assertEquals(2, process.exitValue());
//    }

    private String getStdOut(Process process) throws IOException {
        return readFully(process.getInputStream());
    }

    private String getStdErr(Process process) throws IOException {
        return readFully(process.getErrorStream());
    }

    private String readFully(InputStream in) throws IOException {
        byte[] buff = new byte[10 * 1024];
        int len = 0;
        int total = 0;
        while ((len = in.read(buff, total, buff.length - total)) > 0) {
            total += len;
        }
        return new String(buff, 0, total);
    }
}
