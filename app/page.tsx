import Container from "@mui/material/Container";
import Typography from "@mui/material/Typography";

export default function HomePage() {
  return (
    <Container component="main" maxWidth="sm" sx={{ py: { xs: 6, sm: 10 } }}>
      <Typography variant="h1" component="h1">
        Safe to Spend — coming together
      </Typography>
    </Container>
  );
}
